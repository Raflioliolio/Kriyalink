import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// State: null = belum load, '' = belum onboarding, 'umkm'/'kreator' = sudah
class AuthNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return authService.getSavedRole();
  }

  Future<void> setRole(String role) async {
    state = const AsyncLoading();
    await authService.saveRole(role);
    state = AsyncData(role);
  }

  Future<void> logout() async {
    await authService.clearRole();
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, String?>(
  AuthNotifier.new,
);

// Simple sync role provider (read from prefs cache)
final roleProvider = FutureProvider<String?>((ref) async {
  return authService.getSavedRole();
});
