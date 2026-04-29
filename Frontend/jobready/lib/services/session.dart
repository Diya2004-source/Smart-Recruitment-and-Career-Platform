import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static String? token;
  static String? role;

  // SAVE
  static Future<void> saveSession(String t, String r) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", t);
    await prefs.setString("role", r);

    token = t;
    role = r;
  }

  // LOAD
  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    role = prefs.getString("role");
  }

  // LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    token = null;
    role = null;
  }
}