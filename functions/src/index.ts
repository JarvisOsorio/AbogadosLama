import { onDocumentCreated, FirestoreEvent, QueryDocumentSnapshot } from "firebase-functions/v2/firestore";
import { onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { GoogleGenAI } from "@google/genai";
import { INTAKE_AGENT_PROMPT } from "./agentPrompt";
import axios from "axios";
import * as nodemailer from "nodemailer";

// ── Initialize Firebase Admin SDK ──────────────────────────────────────────
admin.initializeApp();

// ── Shared resource-cap options (applied to both triggers) ─────────────────
// maxInstances: hard ceiling — blocks auto-scale DDoS billing exploits
// memory:       256MiB sufficient for email/webhook dispatch
// timeoutSeconds: aggressively kills hung or looping invocations
const FUNCTION_OPTIONS = {
  maxInstances:   2,              // Hard ceiling — prevents runaway scaling
  memory:         "256MiB" as const,
  timeoutSeconds: 60,             // Kill hung requests before cost accumulates
  region:         "us-central1" as const,
};

// ── Input validation constants (anti-spam / DDoS payload guard) ────────────
const MAX_FIELD_LENGTH = 1000;   // chars — rejects oversized injection payloads
const MAX_NAME_LENGTH  = 120;
const MAX_EMAIL_LENGTH = 254;    // RFC 5321 maximum
const MAX_PHONE_LENGTH = 20;

// ── Interface representing the standard database model schema ──────────────
interface LeadPayload {
  requirement_type?:  string;
  urgency_state?:     string;
  case_description?:  string;
  client_name?:       string;
  client_email?:      string;
  contact_phone?:     string;
  created_at?:        admin.firestore.Timestamp;
  _processed?:        boolean; // idempotency sentinel flag
  _rejected?:         boolean;
  _reject_reason?:    string;
}

// ── Payload size guard: reject oversized / malformed documents ─────────────
function isPayloadSafe(data: LeadPayload): boolean {
  if ((data.client_name      || "").length > MAX_NAME_LENGTH)    return false;
  if ((data.client_email     || "").length > MAX_EMAIL_LENGTH)   return false;
  if ((data.contact_phone    || "").length > MAX_PHONE_LENGTH)   return false;
  if ((data.case_description || "").length > MAX_FIELD_LENGTH)   return false;
  if ((data.requirement_type || "").length > 50)                 return false;
  if ((data.urgency_state    || "").length > 50)                 return false;
  return true;
}

/**
 * Shared lead processing engine.
 * Compiles formatted priority text and routes alerts to Rossy Lama.
 *
 * Cost-control protections:
 *  - Idempotency check: skips re-execution on Cloud Function retries
 *  - Field-size validation: rejects abuse payloads before any I/O
 *  - Axios timeout: 15s hard ceiling prevents hung HTTP from draining timeout budget
 *  - SMTP timeouts: 10s connection + 15s socket to kill stalled SMTP sessions
 */
async function processAndRouteLead(
  snap:             QueryDocumentSnapshot | undefined,
  leadId:           string,
  sourceCollection: string
): Promise<void> {
  if (!snap) {
    console.error("[CostGuard] No document snapshot — aborting.");
    return;
  }

  const data = snap.data() as LeadPayload;

  // ── Idempotency guard: skip if already processed ───────────────────────
  // Prevents double-billing on automatic Cloud Function retries
  if (data._processed === true) {
    console.warn(`[CostGuard] Lead ${leadId} already processed. Skipping duplicate execution.`);
    return;
  }

  // ── Payload size validation ────────────────────────────────────────────
  if (!isPayloadSafe(data)) {
    console.error(`[CostGuard] Lead ${leadId} REJECTED — payload exceeds max field lengths. Possible abuse.`);
    // Mark as processed to stop retry loop from accumulating costs
    await snap.ref.update({
      _processed:     true,
      _rejected:      true,
      _reject_reason: "payload_too_large",
    });
    return;
  }

  // ── Mark as in-flight immediately to block duplicate concurrent triggers ─
  try {
    await snap.ref.update({
      _processed:    true,
      _processed_at: admin.firestore.FieldValue.serverTimestamp(),
    });
  } catch (updateErr: any) {
    // Non-fatal — log and continue to deliver the notification
    console.warn(`[CostGuard] Could not set _processed flag on ${leadId}:`, updateErr.message);
  }

  console.log(`[Router] Processing lead ${leadId} from '${sourceCollection}'`);

  // ── Safe field extraction ──────────────────────────────────────────────
  const requirementType = data.requirement_type  || "No especificado";
  const urgencyState    = data.urgency_state     || "No especificado";
  const caseDescription = data.case_description  || "Sin descripción proporcionada";
  const clientName      = data.client_name       || "Cliente anónimo";
  const clientEmail     = data.client_email      || "Sin correo";
  const contactPhone    = data.contact_phone     || "Sin teléfono";

  const isEmergency =
    urgencyState.toLowerCase() === "emergency" ||
    urgencyState.toLowerCase() === "urgencia judicial";

  // ── Compile notification body ──────────────────────────────────────────
  let notificationBody = "";
  if (isEmergency) {
    notificationBody += "🚨 [ALERTA DE RETENCIÓN URGENTE - ABOGADOS LAMA] 🚨\n\n";
  } else {
    notificationBody += "💼 [Nuevo Requerimiento - Abogados Lama]\n\n";
  }
  notificationBody += `• Cliente: ${clientName}\n`;
  notificationBody += `• Clasificación: ${requirementType}\n`;
  notificationBody += `• Estado de Riesgo: ${urgencyState.toUpperCase()}\n`;
  notificationBody += `• Contacto Directo: ${contactPhone} (${clientEmail})\n\n`;
  notificationBody += "• Resumen Ejecutivo del Caso:\n";
  notificationBody += `"${caseDescription}"\n\n`;
  notificationBody += `Identificador del Documento: ${leadId}\n`;
  notificationBody += `Origen: ${sourceCollection}`;

  console.log("[Router] Notification compiled.");

  // ── OPTION A: Webhook dispatch (Axios HTTP POST) ───────────────────────
  const webhookUrl = process.env.INTAKE_WEBHOOK_URL;
  if (webhookUrl) {
    try {
      console.log(`[Router] Option A: dispatching webhook to ${webhookUrl}`);
      await axios.post(webhookUrl, {
        lead_id:           leadId,
        collection:        sourceCollection,
        formatted_message: notificationBody,
        is_emergency:      isEmergency,
        payload:           { clientName, clientEmail, contactPhone, requirementType, urgencyState, caseDescription },
      }, {
        timeout: 15000, // 15s hard cap — prevents axios from hanging the function lifetime
      });
      console.log("[Router] Option A: webhook dispatched successfully.");
    } catch (err: any) {
      console.error("[Router] Option A error:", err.message);
    }
  } else {
    console.log("[Router] Option A skipped: INTAKE_WEBHOOK_URL not set.");
  }

  // ── OPTION B: SMTP email dispatch (Nodemailer) ─────────────────────────
  const smtpHost    = process.env.SMTP_HOST || "smtp.gmail.com";
  const smtpPort    = parseInt(process.env.SMTP_PORT || "465", 10);
  const smtpUser    = process.env.SMTP_USER;
  const smtpPass    = process.env.SMTP_PASS || process.env.SMTP_SECRET_TOKEN;
  const targetInbox = process.env.ROSSY_INBOX_EMAIL || "rtlama@icloud.com";

  if (smtpUser && smtpPass) {
    try {
      console.log(`[Router] Option B: dispatching email via ${smtpHost}:${smtpPort}`);
      const transporter = nodemailer.createTransport({
        host:   smtpHost,
        port:   smtpPort,
        secure: smtpPort === 465,
        auth:   { user: smtpUser, pass: smtpPass },
        // Explicit timeouts prevent SMTP sessions from hanging and draining function lifetime
        connectionTimeout: 10000,
        greetingTimeout:   10000,
        socketTimeout:     15000,
      });

      const subject = isEmergency
        ? `🚨 URGENTE: Retención de Caso - ${clientName}`
        : `Nuevo Lead Inbound: Requerimiento - ${clientName}`;

      await transporter.sendMail({
        from:    `"Alerta Abogados Lama" <${smtpUser}>`,
        to:      targetInbox,
        subject: subject,
        text:    notificationBody,
      });
      console.log(`[Router] Option B: email dispatched to ${targetInbox} successfully.`);
    } catch (err: any) {
      console.error("[Router] Option B email error:", err.message);
    }
  } else {
    console.log("[Router] Option B skipped: SMTP credentials not configured.");
  }

  console.log(`[Router] Lead ${leadId} fully processed.`);
}

// ═══════════════════════════════════════════════════════════════════════════
// TRIGGER 1 — 'leads' collection
// Cost caps: maxInstances=2 | memory=256MiB | timeout=60s | region=us-central1
// ═══════════════════════════════════════════════════════════════════════════
exports.onNewLeadTrigger = onDocumentCreated(
  {
    document: "leads/{leadId}",
    ...FUNCTION_OPTIONS,
  },
  async (event: FirestoreEvent<QueryDocumentSnapshot | undefined>) => {
    await processAndRouteLead(event.data, event.params.leadId, "leads");
  }
);

// ═══════════════════════════════════════════════════════════════════════════
// TRIGGER 2 — 'triage_leads' collection
// Cost caps: maxInstances=2 | memory=256MiB | timeout=60s | region=us-central1
// ═══════════════════════════════════════════════════════════════════════════
exports.onNewTriageLeadTrigger = onDocumentCreated(
  {
    document: "triage_leads/{leadId}",
    ...FUNCTION_OPTIONS,
  },
  async (event: FirestoreEvent<QueryDocumentSnapshot | undefined>) => {
    await processAndRouteLead(event.data, event.params.leadId, "triage_leads");
  }
);

// ═══════════════════════════════════════════════════════════════════════════
// TRIGGER 3 — 'intakeChatbot' HTTP Endpoint (AI Agent)
// ═══════════════════════════════════════════════════════════════════════════
exports.intakeChatbot = onRequest(
  {
    cors: true,
    maxInstances: 2,
    memory: "256MiB",
  },
  async (req, res) => {
    try {
      const apiKey = process.env.GEMINI_API_KEY;
      if (!apiKey) {
        res.status(500).send({ error: "API Key not configured." });
        return;
      }

      // We expect a JSON payload with an array of messages
      // Format: { history: [{ role: 'user'|'model', parts: [{text: string}] }], message: string }
      const { message, history } = req.body;
      
      if (!message && !history) {
        res.status(400).send({ error: "Missing message or history array." });
        return;
      }

      const ai = new GoogleGenAI({ apiKey });

      const chat = ai.chats.create({
        model: "gemini-2.5-flash",
        config: {
          systemInstruction: INTAKE_AGENT_PROMPT,
        },
        history: history || [], // Initialize with past history if provided
      });

      let responseText = "";
      if (message) {
        const response = await chat.sendMessage({ message });
        responseText = response.text || "";
      } else {
        // Just return the agent greeting if no user message provided but triggered
        responseText = "Usted se ha comunicado con la línea de evaluación prioritaria de Abogados Lama Estudio Jurídico. Para poder determinar la viabilidad procesal y el nivel de riesgo de su caso, requiero que me informe de forma inmediata: ¿Qué tipo de emergencia legal, notificación judicial o embargo está enfrentando el día de hoy?";
      }

      res.status(200).send({ reply: responseText });
    } catch (error: any) {
      console.error("[intakeChatbot] Error processing request:", error);
      res.status(500).send({ error: "Error processing the chat request." });
    }
  }
);
