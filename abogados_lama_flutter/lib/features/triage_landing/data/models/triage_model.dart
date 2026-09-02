import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/lead_entity.dart';
import '../../domain/entities/triage_entity.dart';

class TriageModel extends TriageEntity {
  const TriageModel({
    required super.requirementType,
    required super.urgencyState,
    required super.caseDescription,
    required super.clientName,
    required super.clientEmail,
    required super.contactPhone,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'requirement_type': requirementType == RequirementType.business ? 'business' : 'personal',
      'urgency_state': urgencyState == UrgencyState.preventative ? 'preventative' : 'emergency',
      'case_description': caseDescription,
      'client_name': clientName,
      'client_email': clientEmail,
      'contact_phone': contactPhone,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  factory TriageModel.fromEntity(TriageEntity entity) {
    return TriageModel(
      requirementType: entity.requirementType,
      urgencyState: entity.urgencyState,
      caseDescription: entity.caseDescription,
      clientName: entity.clientName,
      clientEmail: entity.clientEmail,
      contactPhone: entity.contactPhone,
    );
  }
}
