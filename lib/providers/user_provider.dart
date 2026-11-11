import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../infrastructure/firestore_user_repository.dart';
import '../core/constants.dart';

final _repo = FirestoreUserRepository();

// All kreators list
final kreatorsProvider = FutureProvider<List<UserModel>>((ref) async {
  try {
    return await _repo.getUsersByRole(kRoleKreator);
  } catch (_) {
    // Return dummy data if Firestore not configured yet
    return _dummyKreators;
  }
});

// Filtered kreators by skill/category
final filteredKreatorsProvider =
    Provider.family<AsyncValue<List<UserModel>>, String>((ref, category) {
  final kreators = ref.watch(kreatorsProvider);
  if (category == 'Semua') return kreators;
  return kreators.whenData(
    (list) => list
        .where((k) => k.skills.any(
              (s) => s.toLowerCase().contains(category.toLowerCase()),
            ))
        .toList(),
  );
});

// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected category filter
final selectedCategoryProvider = StateProvider<String>((ref) => 'Semua');

// Single user by ID
final userByIdProvider =
    FutureProvider.family<UserModel?, String>((ref, id) async {
  try {
    return await _repo.getUserById(id);
  } catch (_) {
    return null;
  }
});

// Dummy kreators for demo (when Firebase not set up)
final _dummyKreators = [
  UserModel(
    id: 'k1',
    name: 'Andi Kreatif',
    role: kRoleKreator,
    phone: '08111234567',
    city: 'Surabaya',
    bio: 'Desainer grafis spesialis branding UMKM makanan & minuman. 5 tahun pengalaman.',
    profileImage: 'https://i.pravatar.cc/150?img=11',
    skills: ['Logo', 'Packaging'],
    priceStart: 150000,
    rating: 4.8,
    jobCount: 23,
  ),
  UserModel(
    id: 'k2',
    name: 'Sari Fotografi',
    role: kRoleKreator,
    phone: '08222345678',
    city: 'Malang',
    bio: 'Fotografer produk profesional. Spesialis foto kuliner dan kerajinan tangan.',
    profileImage: 'https://i.pravatar.cc/150?img=5',
    skills: ['Fotografi', 'Sosial Media'],
    priceStart: 200000,
    rating: 4.9,
    jobCount: 41,
  ),
  UserModel(
    id: 'k3',
    name: 'Budi Design',
    role: kRoleKreator,
    phone: '08333456789',
    city: 'Surabaya',
    bio: 'Desainer packaging dan branding untuk UMKM fashion & kerajinan.',
    profileImage: 'https://i.pravatar.cc/150?img=15',
    skills: ['Packaging', 'Logo'],
    priceStart: 120000,
    rating: 4.7,
    jobCount: 18,
  ),
  UserModel(
    id: 'k4',
    name: 'Dewi Sosmed',
    role: kRoleKreator,
    phone: '08444567890',
    city: 'Sidoarjo',
    bio: 'Content creator dan social media specialist untuk UMKM lokal.',
    profileImage: 'https://i.pravatar.cc/150?img=9',
    skills: ['Sosial Media', 'Fotografi'],
    priceStart: 100000,
    rating: 4.6,
    jobCount: 35,
  ),
  UserModel(
    id: 'k5',
    name: 'Raka Visual',
    role: kRoleKreator,
    phone: '08555678901',
    city: 'Gresik',
    bio: 'Full branding service: logo, packaging, foto produk, konten medsos.',
    profileImage: 'https://i.pravatar.cc/150?img=12',
    skills: ['Logo', 'Packaging', 'Fotografi', 'Sosial Media'],
    priceStart: 300000,
    rating: 5.0,
    jobCount: 7,
  ),
];
