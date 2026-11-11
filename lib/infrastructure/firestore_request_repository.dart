import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/request_model.dart';

/// Service requests live in a top-level collection: requests/{requestId}
class FirestoreRequestRepository {
  final FirebaseFirestore _firestore;

  FirestoreRequestRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _requestsRef =>
      _firestore.collection('requests');

  /// Get all requests submitted by a specific UMKM.
  Future<List<ServiceRequest>> getRequestsByUmkm(String umkmId) async {
    final snapshot = await _requestsRef
        .where('umkmId', isEqualTo: umkmId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => ServiceRequest.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  /// Get all requests assigned to a specific Kreator.
  Future<List<ServiceRequest>> getRequestsByKreator(String kreatorId) async {
    final snapshot = await _requestsRef
        .where('kreatorId', isEqualTo: kreatorId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => ServiceRequest.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  /// Create or update a service request.
  Future<void> saveRequest(ServiceRequest request) async {
    await _requestsRef
        .doc(request.id)
        .set(request.toMap(), SetOptions(merge: true));
  }

  /// Update only the status field of an existing request.
  Future<void> updateStatus(String id, String status) async {
    await _requestsRef.doc(id).update({'status': status});
  }
}
