import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/request_model.dart';
import '../infrastructure/firestore_request_repository.dart';

final _repo = FirestoreRequestRepository();

// Requests for UMKM
final umkmRequestsProvider =
    FutureProvider.family<List<ServiceRequest>, String>((ref, umkmId) async {
  try {
    return await _repo.getRequestsByUmkm(umkmId);
  } catch (_) {
    return [];
  }
});

// Requests for Kreator
final kreatorRequestsProvider =
    FutureProvider.family<List<ServiceRequest>, String>((ref, kreatorId) async {
  try {
    return await _repo.getRequestsByKreator(kreatorId);
  } catch (_) {
    return _dummyRequests;
  }
});

// Submit a new request
class RequestNotifier extends Notifier<AsyncValue<bool?>> {
  @override
  AsyncValue<bool?> build() => const AsyncData(null);

  Future<void> submitRequest(ServiceRequest request) async {
    state = const AsyncLoading();
    try {
      await _repo.saveRequest(request);
      state = const AsyncData(true);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void reset() => state = const AsyncData(null);
}

final requestNotifierProvider =
    NotifierProvider<RequestNotifier, AsyncValue<bool?>>(
  RequestNotifier.new,
);

// Dummy requests for demo
final _dummyRequests = [
  ServiceRequest(
    id: 'r1',
    umkmId: 'u1',
    kreatorId: 'k1',
    serviceType: 'logo',
    description: 'Butuh desain logo untuk brand keripik singkong saya. Nuansa tradisional tapi tetap modern.',
    budgetRange: 'Rp 100-200rb',
    deadline: DateTime.now().add(const Duration(days: 7)),
    status: 'pending',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  ServiceRequest(
    id: 'r2',
    umkmId: 'u2',
    kreatorId: 'k1',
    serviceType: 'packaging',
    description: 'Desain packaging untuk produk kue basah. Target premium, ukuran kotak 20x20cm.',
    budgetRange: 'Rp 200-500rb',
    deadline: DateTime.now().add(const Duration(days: 14)),
    status: 'pending',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
];
