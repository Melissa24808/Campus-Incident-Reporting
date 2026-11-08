import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/incident.dart';

class IncidentService {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('incidents');

  /// Real-time stream: the list updates by itself when data changes.
  Stream<List<Incident>> watchIncidents() {
    return _col
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Incident.fromDoc).toList());
  }

  Future<void> create(Incident incident) => _col.add(incident.toMap());

  Future<void> updateStatus(String id, String status) {
    return _col.doc(id).update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}