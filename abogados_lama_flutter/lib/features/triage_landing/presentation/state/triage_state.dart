import '../../domain/entities/lead_entity.dart';

enum TriageStatus { initial, submitting, success, failure }

class TriageState {
  final int currentStep;
  final RequirementType requirementType;
  final UrgencyState urgencyState;
  final String caseDescription;
  final String clientName;
  final String clientEmail;
  final String contactPhone;
  final TriageStatus status;
  final String? successTrackingCode;
  final String? errorMessage;

  const TriageState({
    this.currentStep = 1,
    this.requirementType = RequirementType.none,
    this.urgencyState = UrgencyState.none,
    this.caseDescription = '',
    this.clientName = '',
    this.clientEmail = '',
    this.contactPhone = '',
    this.status = TriageStatus.initial,
    this.successTrackingCode,
    this.errorMessage,
  });

  TriageState copyWith({
    int? currentStep,
    RequirementType? requirementType,
    UrgencyState? urgencyState,
    String? caseDescription,
    String? clientName,
    String? clientEmail,
    String? contactPhone,
    TriageStatus? status,
    String? successTrackingCode,
    String? errorMessage,
  }) {
    return TriageState(
      currentStep: currentStep ?? this.currentStep,
      requirementType: requirementType ?? this.requirementType,
      urgencyState: urgencyState ?? this.urgencyState,
      caseDescription: caseDescription ?? this.caseDescription,
      clientName: clientName ?? this.clientName,
      clientEmail: clientEmail ?? this.clientEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      status: status ?? this.status,
      successTrackingCode: successTrackingCode ?? this.successTrackingCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isStep1Valid => requirementType != RequirementType.none;
  bool get isStep2Valid => urgencyState != UrgencyState.none;
  bool get isStep3Valid => caseDescription.trim().length >= 15;
  bool get isStep4Valid =>
      clientName.trim().isNotEmpty &&
      clientEmail.contains('@') &&
      contactPhone.replaceAll(RegExp(r'\s+'), '').length == 9 &&
      contactPhone.startsWith('9');

  LeadEntity toEntity() {
    return LeadEntity(
      requirementType: requirementType,
      urgencyState: urgencyState,
      caseDescription: caseDescription,
      clientName: clientName,
      clientEmail: clientEmail,
      contactPhone: '+56 $contactPhone',
    );
  }
}
