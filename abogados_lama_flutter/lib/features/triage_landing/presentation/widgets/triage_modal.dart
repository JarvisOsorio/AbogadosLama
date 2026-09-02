import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/lead_entity.dart';
import '../state/triage_provider.dart';
import '../state/triage_state.dart';

class TriageModal extends StatefulWidget {
  final TriageNotifier notifier;

  const TriageModal({super.key, required this.notifier});

  @override
  State<TriageModal> createState() => _TriageModalState();
}

class _TriageModalState extends State<TriageModal> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 540),
        decoration: BoxDecoration(
          color: AppTheme.primaryNavy.withOpacity(0.95),
          border: Border.all(color: AppTheme.primaryGold.withOpacity(0.25), width: 1),
        ),
        padding: const EdgeInsets.all(32.0),
        child: ValueListenableBuilder<TriageState>(
          valueListenable: widget.notifier,
          builder: (context, state, _) {
            if (state.status == TriageStatus.success) {
              return _buildSuccessScreen(context, state);
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, state),
                const SizedBox(height: 24),
                _buildProgressBar(state),
                const SizedBox(height: 32),
                Flexible(
                  child: SingleChildScrollView(
                    child: _buildCurrentStepContent(context, state),
                  ),
                ),
                const SizedBox(height: 32),
                _buildFooterNavigation(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, TriageState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PASO ${state.currentStep} DE 4',
              style: const TextStyle(
                color: AppTheme.primaryGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Triage Legal Asistido',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, color: AppTheme.textMuted),
        ),
      ],
    );
  }

  Widget _buildProgressBar(TriageState state) {
    final double percentage = state.currentStep / 4.0;
    return Container(
      width: double.infinity,
      height: 6,
      color: AppTheme.outlineVariant.withOpacity(0.4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: percentage,
          child: Container(
            color: AppTheme.primaryGold,
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(BuildContext context, TriageState state) {
    switch (state.currentStep) {
      case 1:
        return _buildStep1(state);
      case 2:
        return _buildStep2(state);
      case 3:
        return _buildStep3(state);
      case 4:
        return _buildStep4(state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStep1(TriageState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Qué tipo de asesoría requiere?',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textLight,
          ),
        ),
        const SizedBox(height: 24),
        _buildRadioCard(
          title: 'Empresa (Laboral / Ley Karin / Compliance)',
          description: 'Asesoría para PYMES, auditorías internas, contratos y compliance penal.',
          selected: state.requirementType == RequirementType.business,
          onTap: () => widget.notifier.setRequirementType(RequirementType.business),
        ),
        const SizedBox(height: 16),
        _buildRadioCard(
          title: 'Persona Natural (Civil / Propiedades / Herencias)',
          description: 'Bienes raíces, posesiones efectivas, disputas de arriendo y defensa de deudas.',
          selected: state.requirementType == RequirementType.personal,
          onTap: () => widget.notifier.setRequirementType(RequirementType.personal),
        ),
      ],
    );
  }

  Widget _buildStep2(TriageState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¿Cuál es el estado del problema?',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textLight,
          ),
        ),
        const SizedBox(height: 24),
        _buildRadioCard(
          title: 'Preventivo (Quiero evitar un problema)',
          description: 'Redacción de contratos, asesoría proactiva, adecuación a regulaciones.',
          selected: state.urgencyState == UrgencyState.preventative,
          onTap: () => widget.notifier.setUrgencyState(UrgencyState.preventative),
        ),
        const SizedBox(height: 16),
        _buildRadioCard(
          title: 'Urgencia Judicial (Ya fui notificado / Demandado / Tengo una fiscalización)',
          description: 'Tengo plazos legales corriendo de tribunales o instituciones fiscalizadoras.',
          selected: state.urgencyState == UrgencyState.emergencyJudicial,
          onTap: () => widget.notifier.setUrgencyState(UrgencyState.emergencyJudicial),
        ),
      ],
    );
  }

  Widget _buildStep3(TriageState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Breve descripción de su caso',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textLight,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Indique detalles esenciales para la pre-evaluación del equipo de abogados.',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 24),
        TextField(
          maxLines: 5,
          maxLength: 300,
          onChanged: widget.notifier.setCaseDescription,
          decoration: const InputDecoration(
            hintText: 'Escriba los hechos principales y la ayuda que requiere...',
          ),
        ),
        if (state.caseDescription.isNotEmpty && !state.isStep3Valid)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Por favor, escriba al menos 15 caracteres.',
              style: TextStyle(color: AppTheme.errorRed, fontSize: 12),
            ),
          )
      ],
    );
  }

  Widget _buildStep4(TriageState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información de Contacto Directo',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textLight,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          onChanged: (_) => _updateContactDetails(),
          decoration: const InputDecoration(
            labelText: 'Nombre Completo',
            hintText: 'Ej. Jarvis Nelson Osorio',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          onChanged: (_) => _updateContactDetails(),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
            hintText: 'Ej. jarvis@ejemplo.cl',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainer,
                border: Border.all(color: AppTheme.outlineVariant),
              ),
              child: const Center(
                child: Text(
                  '+56',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _phoneController,
                onChanged: (_) => _updateContactDetails(),
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'WhatsApp / Teléfono Móvil',
                  hintText: '9 1234 5678',
                ),
              ),
            ),
          ],
        ),
        if (_phoneController.text.isNotEmpty && !state.isStep4Valid)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Ingrese un correo válido y un número chileno de 9 dígitos (ej. 9 1234 5678).',
              style: TextStyle(color: AppTheme.errorRed, fontSize: 12),
            ),
          )
      ],
    );
  }

  void _updateContactDetails() {
    widget.notifier.setContactDetails(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );
  }

  Widget _buildRadioCard({
    required String title,
    required String description,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryGold.withOpacity(0.08)
              : AppTheme.surfaceContainer.withOpacity(0.4),
          border: Border.all(
            color: selected ? AppTheme.primaryGold : AppTheme.outlineVariant,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppTheme.primaryGold : AppTheme.textMuted,
                  width: 2,
                ),
                color: selected ? AppTheme.primaryGold : Colors.transparent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFooterNavigation(TriageState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: state.currentStep > 1 ? widget.notifier.prevStep : null,
          child: const Text('ATRÁS'),
        ),
        if (state.status == TriageStatus.submitting)
          const CircularProgressIndicator(color: AppTheme.primaryGold)
        else
          ElevatedButton(
            onPressed: () {
              if (state.currentStep < 4) {
                final success = widget.notifier.nextStep();
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, complete los datos requeridos.'),
                      backgroundColor: AppTheme.errorRed,
                    ),
                  );
                }
              } else {
                widget.notifier.submit();
              }
            },
            child: Text(state.currentStep == 4 ? 'ENVIAR SOLICITUD' : 'SIGUIENTE'),
          )
      ],
    );
  }

  Widget _buildSuccessScreen(BuildContext context, TriageState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppTheme.primaryGold,
            size: 64,
          ),
          const SizedBox(height: 24),
          const Text(
            'Evaluación Iniciada',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Estimado/a ${state.clientName}, hemos recibido su requerimiento de tipo ${state.requirementType == RequirementType.business ? 'Empresa' : 'Persona Natural'}.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: Text(
              'Código de Seguimiento: ${state.successTrackingCode}',
              style: const TextStyle(
                fontFamily: 'Inter',
                color: AppTheme.primaryGold,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Un Abogado Sénior asignado revisará la viabilidad de su caso y se comunicará vía WhatsApp en un plazo máximo de 2 horas hábiles.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMuted, fontSize: 11, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.notifier.reset();
            },
            child: const Text('CERRAR VENTANA'),
          )
        ],
      ),
    );
  }
}
