import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/constants.dart';

class Incident {
  final String id;
  final String title;
  final String description;
  final String category;
  final String location;
  final String status;
  final String? imageUrl;
  final String reporterId;
  final String reporterName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    this.status = IncidentStatus.submitted,
    this.imageUrl,
    required this.reporterId,
    required this.reporterName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Incident.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Incident(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      location: data['location'] ?? '',
      status: data['status'] ?? IncidentStatus.submitted,
      imageUrl: data['imageUrl'],
      reporterId: data['reporterId'] ?? '',
      reporterName: data['reporterName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'category': category,
        'location': location,
        'status': status,
        'imageUrl': imageUrl,
        'reporterId': reporterId,
        'reporterName': reporterName,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };
}