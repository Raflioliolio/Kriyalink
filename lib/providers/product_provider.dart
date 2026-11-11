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

// Product CRUD notifier
class ProductNotifier extends AsyncNotifier<List<ProductModel>> {
  final String userId;
  ProductNotifier(this.userId);

  @override
  Future<List<ProductModel>> build() async {
    try {
      return await _repo.getProductsByUser(userId);
    } catch (_) {
      return [];
    }
  }

  Future<void> addProduct(ProductModel product) async {
    final prev = state.valueOrNull ?? [];
    state = AsyncData([...prev, product]);
    try {
      await _repo.saveProduct(product);
    } catch (_) {
      state = AsyncData(prev);
    }
  }

  Future<void> removeProduct(String productId) async {
    final prev = state.valueOrNull ?? [];
    state = AsyncData(prev.where((p) => p.id != productId).toList());
    try {
      await _repo.deleteProduct(userId, productId);
    } catch (_) {
      state = AsyncData(prev);
    }
  }
}

final productNotifierProvider = AsyncNotifierProvider.family<ProductNotifier,
    List<ProductModel>, String>(
  ProductNotifier.new,
);
