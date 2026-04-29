import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static String? token;
  static String? role;

  // ================= SAVE SESSION =================
  static Future<void> saveSession(String t, String r) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", t);
    await prefs.setString("role", r);

    token = t;
    role = r;
  }

  // ================= LOAD SESSION =================
  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    role = prefs.getString("role");
  }

  // ================= GET TOKEN (🔥 FIX) =================
  static Future<String?> getToken() async {
    if (token != null) return token;

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    return token;
  }

  // ================= GET ROLE =================
  static Future<String?> getRole() async {
    if (role != null) return role;

    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString("role");

    return role;
  }

  // ================= CHECK LOGIN =================
  static Future<bool> isLoggedIn() async {
    final t = await getToken();
    return t != null && t.isNotEmpty;
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    token = null;
    role = null;
  }
}