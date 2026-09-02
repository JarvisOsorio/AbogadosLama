import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/triage_model.dart';

abstract class TriageFirestoreDataSource {
  Future<String> submitTriageLead(TriageModel model);
}

class TriageFirestoreDataSourceImpl implements TriageFirestoreDataSource {
  final FirebaseFirestore _firestore;

  TriageFirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<String> submitTriageLead(TriageModel model) async {
    try {
      final docRef = await _firestore.collection('triage_leads').add(model.toFirestore());
      return docRef.id; // Returns document reference ID as success token
    } catch (e) {
      throw Exception('Error al enviar la solicitud legal a Firestore: $e');
    }
  }
}
