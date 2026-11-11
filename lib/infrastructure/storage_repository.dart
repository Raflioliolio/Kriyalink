import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Handles image uploads/deletions via Firebase Storage.
class StorageRepository {
  final FirebaseStorage _storage;

  StorageRepository({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Upload a file to Firebase Storage at the given [path] and return the
  /// public download URL.
  ///
  /// Example path: 'users/$userId/profile.jpg' or
  /// 'portfolio/$kreatorId/$itemId.jpg'.
  Future<String> uploadImage(File file, String path) async {
    final ref = _storage.ref().child(path);
    final uploadTask = await ref.putFile(file);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Delete an image from Firebase Storage by its storage [path].
  Future<void> deleteImage(String path) async {
    final ref = _storage.ref().child(path);
    await ref.delete();
  }
}
