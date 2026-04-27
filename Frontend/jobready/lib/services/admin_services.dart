import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminApiService {
  final String baseUrl = "http://10.0.2.2:8000/api/accounts";

  Future<List> getUsers(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/users/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to load users");
  }

  Future<void> updateUserRole(String token, int id, String role) async {
    await http.patch(
      Uri.parse("$baseUrl/users/$id/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"role": role}),
    );
  }

  Future<void> deleteUser(String token, int id) async {
    await http.delete(
      Uri.parse("$baseUrl/users/$id/"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future<Map<String, dynamic>> getDashboard(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/admin/dashboard/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Dashboard error");
  }
}