import 'dart:math';
import '../../domain/entities/lead_entity.dart';
import '../../domain/usecases/submit_triage.dart';
import '../models/lead_model.dart';

abstract class TriageRemoteDataSource {
  Future<String> sendLead(LeadModel model);
}

class TriageRemoteDataSourceImpl implements TriageRemoteDataSource {
  @override
  Future<String> sendLead(LeadModel model) async {
    // Simulated network delay representing API submit to Stitch backend/firebase
    await Future.delayed(const Duration(milliseconds: 1500));
    final randomId = 1000 + Random().nextInt(9000);
    return 'AL-$randomId-2026';
  }
}

class TriageRepositoryImpl implements TriageRepository {
  final TriageRemoteDataSource remoteDataSource;

  TriageRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> submitLead(LeadEntity lead) async {
    final model = LeadModel.fromEntity(lead);
    return await remoteDataSource.sendLead(model);
  }
}
