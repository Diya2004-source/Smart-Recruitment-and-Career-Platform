import 'dart:convert';
import 'package:http/http.dart' as http;

class UserModel {
  final int id;
  final String username;
  final String email;
  final String role;

  UserModel({required this.id, required this.username, required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: json['role'] ?? 'CANDIDATE',
    );
  }
}

class AdminApiService {
  final String baseUrl = "http://10.0.2.2:8000/api/accounts";

  Future<List<UserModel>> getUsers(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/users/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      return body.map((item) => UserModel.fromJson(item)).toList();
    }
    throw Exception("Failed to load users");
  }

  Future<bool> deleteUser(String token, int id) async {
    final res = await http.delete(
      Uri.parse("$baseUrl/users/$id/"),
      headers: {"Authorization": "Bearer $token"},
    );
    return res.statusCode == 204 || res.statusCode == 200;
  }

  Future<Map<String, dynamic>> getDashboard(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/admin/dashboard/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Dashboard error: ${res.statusCode}");
  }
}