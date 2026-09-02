import '../../domain/entities/lead_entity.dart';

class LeadModel extends LeadEntity {
  const LeadModel({
    required super.requirementType,
    required super.urgencyState,
    required super.caseDescription,
    required super.clientName,
    required super.clientEmail,
    required super.contactPhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'requirementType': requirementType.name,
      'urgencyState': urgencyState.name,
      'caseDescription': caseDescription,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'contactPhone': contactPhone,
    };
  }

  factory LeadModel.fromEntity(LeadEntity entity) {
    return LeadModel(
      requirementType: entity.requirementType,
      urgencyState: entity.urgencyState,
      caseDescription: entity.caseDescription,
      clientName: entity.clientName,
      clientEmail: entity.clientEmail,
      contactPhone: entity.contactPhone,
    );
  }
}
