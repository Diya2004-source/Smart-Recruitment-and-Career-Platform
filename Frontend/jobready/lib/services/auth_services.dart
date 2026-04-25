import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // 🔥 FIXED BASE URL (added /accounts/)
  final String baseUrl = "http://10.0.2.2:8000/api/accounts";

  // ================= REGISTER =================
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/users/'); // ✅ FIXED

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "role": role,
        }),
      );

      final data = _decodeResponse(response);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          "success": true,
          "message": data["message"] ?? "Registration successful",
        };
      } else {
        return {
          "success": false,
          "message": _formatError(data),
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Server not reachable. Please check your backend.",
      };
    }
  }

  // ================= LOGIN =================
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login/'); // ✅ FIXED

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = _decodeResponse(response);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "token": data["token"],
          "user": data["user"],
        };
      } else {
        return {
          "success": false,
          "message": _formatError(data),
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Server not reachable. Try again later.",
      };
    }
  }

  // ================= RESPONSE DECODER =================
  dynamic _decodeResponse(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return {"message": response.body};
    }
  }

  // ================= ERROR FORMATTER =================
  String _formatError(dynamic data) {
    if (data is Map) {
      return data.entries.map((e) {
        if (e.value is List) {
          return "${e.key}: ${(e.value as List).join(', ')}";
        }
        return "${e.key}: ${e.value}";
      }).join("\n");
    }
    return data.toString();
  }
}