import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreUserRepository {
  final FirebaseFirestore _firestore;

  FirestoreUserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  /// Get all users.
  Future<List<UserModel>> getUsers() async {
    final snapshot = await _usersRef.get();
    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  /// Get a single user by document ID.
  Future<UserModel?> getUserById(String id) async {
    final doc = await _usersRef.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return UserModel.fromMap(doc.data()!, id: doc.id);
  }

  /// Get users filtered by role ('umkm' or 'kreator').
  Future<List<UserModel>> getUsersByRole(String role) async {
    final snapshot =
        await _usersRef.where('role', isEqualTo: role).get();
    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  /// Create or update a user document. Uses the user's id as document ID.
  Future<void> saveUser(UserModel user) async {
    await _usersRef.doc(user.id).set(user.toMap(), SetOptions(merge: true));
  }

  /// Delete a user document by ID.
  Future<void> deleteUser(String id) async {
    await _usersRef.doc(id).delete();
  }
}
