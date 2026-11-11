import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

/// Products are stored as a sub-collection under each user document:
/// users/{userId}/products/{productId}
class FirestoreProductRepository {
  final FirebaseFirestore _firestore;

  FirestoreProductRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _productsRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('products');

  /// Get all products for a specific user.
  Future<List<ProductModel>> getProductsByUser(String userId) async {
    final snapshot =
        await _productsRef(userId).orderBy('createdAt', descending: true).get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  /// Create or update a product. Uses product.id as document ID under the
  /// user's products sub-collection.
  Future<void> saveProduct(ProductModel product) async {
    await _productsRef(product.userId)
        .doc(product.id)
        .set(product.toMap(), SetOptions(merge: true));
  }

  /// Delete a product by its ID. Requires the owning userId to locate the
  /// sub-collection.
  Future<void> deleteProduct(String userId, String id) async {
    await _productsRef(userId).doc(id).delete();
  }
}
