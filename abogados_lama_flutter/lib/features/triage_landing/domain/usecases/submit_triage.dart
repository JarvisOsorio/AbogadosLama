import '../entities/lead_entity.dart';

abstract class TriageRepository {
  Future<String> submitLead(LeadEntity lead);
}

class SubmitTriage {
  final TriageRepository repository;

  SubmitTriage(this.repository);

  Future<String> call(LeadEntity lead) async {
    if (!lead.isValid) {
      throw Exception('Datos de requerimiento inválidos o incompletos.');
    }
    return await repository.submitLead(lead);
  }
}
