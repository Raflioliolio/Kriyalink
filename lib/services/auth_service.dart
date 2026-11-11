import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class AuthService {
  static const _keyRole = 'user_role';
  static const _keyOnboarded = 'has_onboarded';

  /// Save role chosen during onboarding
  Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
    await prefs.setBool(_keyOnboarded, true);
  }

  /// Get saved role, null if not onboarded yet
  Future<String?> getSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  /// Check if user has completed onboarding
  Future<bool> hasOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboarded) ?? false;
  }

  /// Clear saved role (logout)
  Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRole);
    await prefs.remove(_keyOnboarded);
  }

  bool isUmkm(String role) => role == kRoleUmkm;
  bool isKreator(String role) => role == kRoleKreator;
}

final authService = AuthService();
