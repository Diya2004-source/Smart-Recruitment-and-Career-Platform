import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const _tokenKey = "access_token";
  static const _roleKey = "role";

  // SAVE LOGIN SESSION
  static Future<void> saveSession(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);
  }

  // GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // GET ROLE
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // FIX FOR YOUR ERROR (main.dart)
  static Future<void> loadSession() async {
    return;
  }
}