import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../infrastructure/firestore_product_repository.dart';

final _repo = FirestoreProductRepository();

// Products for current user
final userProductsProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, userId) async {
  try {
    return await _repo.getProductsByUser(userId);
  } catch (_) {
    return [];
  }
});

// Product CRUD notifier — using StateNotifier for simpler family support
class ProductNotifier extends StateNotifier<List<ProductModel>> {
  final String userId;
  ProductNotifier(this.userId) : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final products = await _repo.getProductsByUser(userId);
      state = products;
    } catch (_) {
      state = [];
    }
  }

  Future<void> addProduct(ProductModel product) async {
    state = [...state, product];
    try {
      await _repo.saveProduct(product);
    } catch (_) {
      state = state.where((p) => p.id != product.id).toList();
    }
  }

  Future<void> removeProduct(String productId) async {
    final prev = state;
    state = prev.where((p) => p.id != productId).toList();
    try {
      await _repo.deleteProduct(userId, productId);
    } catch (_) {
      state = prev;
    }
  }
}

final productNotifierProvider =
    StateNotifierProvider.family<ProductNotifier, List<ProductModel>, String>(
  (ref, userId) => ProductNotifier(userId),
);
