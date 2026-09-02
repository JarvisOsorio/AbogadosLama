enum RequirementType { business, personal, none }

enum UrgencyState { preventative, emergencyJudicial, none }

class LeadEntity {
  final RequirementType requirementType;
  final UrgencyState urgencyState;
  final String caseDescription;
  final String clientName;
  final String clientEmail;
  final String contactPhone;

  const LeadEntity({
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
