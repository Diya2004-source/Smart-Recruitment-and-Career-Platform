// import 'package:shared_preferences/shared_preferences.dart';

// class Session {
//   static const _tokenKey = "access_token";
//   static const _roleKey = "role";

//   // SAVE LOGIN SESSION
//   static Future<void> saveSession(String token, String role) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenKey, token);
//     await prefs.setString(_roleKey, role);
//   }

//   // GET TOKEN
//   static Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_tokenKey);
//   }

//   // GET ROLE
//   static Future<String?> getRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString(_roleKey);
//   }

//   // LOGOUT
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }

//   // FIX FOR YOUR ERROR (main.dart)
//   static Future<void> loadSession() async {
//     return;
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const _tokenKey = "access_token";
  static const _roleKey = "role";

  // Static variable to store the token in memory for instant access
  static String token = ""; 

  // SAVE LOGIN SESSION
  static Future<void> saveSession(String tokenValue, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, tokenValue);
    await prefs.setString(_roleKey, role);
    token = tokenValue; // Update memory
  }

  // GET TOKEN (Async version for general use)
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
    token = ""; // Clear memory
  }

  // LOAD SESSION (Called in main.dart before runApp)
  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey) ?? ""; // Pull from disk to memory
  }
}