import 'lead_entity.dart';

class TriageEntity {
  final RequirementType requirementType;
  final UrgencyState urgencyState;
  final String caseDescription;
  final String clientName;
  final String clientEmail;
  final String contactPhone;

  const TriageEntity({
    required this.requirementType,
    required this.urgencyState,
    required this.caseDescription,
    required this.clientName,
    required this.clientEmail,
    required this.contactPhone,
  });

  bool get isValid =>
      requirementType != RequirementType.none &&
      urgencyState != UrgencyState.none &&
      caseDescription.trim().length >= 15 &&
      clientName.trim().isNotEmpty &&
      clientEmail.contains('@') &&
      contactPhone.replaceFirst('+56', '').replaceAll(RegExp(r'\s+'), '').length == 9;
}
