import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static String? _token;
  static String? _role;

  static Future<void> saveSession(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    await prefs.setString("role", role);

    _token = token;
    _role = role;
  }

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    _role = prefs.getString("role");
  }

  static Future<String?> getToken() async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("token");
    return _token;
  }

  static Future<String?> getRole() async {
    if (_role != null) return _role;

    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString("role");
    return _role;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _token = null;
    _role = null;
  }
}