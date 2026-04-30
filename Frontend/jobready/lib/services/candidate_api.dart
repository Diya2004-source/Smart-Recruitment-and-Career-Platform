import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session.dart';

class CandidateApi {
  // Use 10.0.2.2 for Android Emulator to point to your computer's localhost
  static const String baseUrl = "http://10.0.2.2:8000/api";

  // ================= HEADERS =================
  static Future<Map<String, String>> _headers() async {
    final token = await Session.getToken();
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  // ================= PARSER =================
  // Handles lists, paginated results, and null data safely
  static List<dynamic> _parseList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      if (data.containsKey("results")) return data["results"] ?? [];
      if (data.containsKey("data")) return data["data"] ?? [];
    }
    return [];
  }

  // ================= GET JOBS =================
  static Future<List<dynamic>> getJobs() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/jobs/"),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return _parseList(decoded);
      }
      throw Exception("Jobs API Error: ${response.statusCode}");
    } catch (e) {
      throw Exception("Failed to load jobs: $e");
    }
  }

  // ================= GET APPLICATIONS =================
  static Future<List<dynamic>> getApplications() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/applications/"),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        return _parseList(jsonDecode(response.body));
      }
      throw Exception("Applications Error: ${response.statusCode}");
    } catch (e) {
      throw Exception("Failed to load applications: $e");
    }
  }

  // ================= APPLY JOB =================
  static Future<void> applyJob(int jobId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/applications/"),
      headers: await _headers(),
      body: jsonEncode({"job": jobId}),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Apply failed: ${response.body}");
    }
  }

  // ================= PROFILE (FIXED 404) =================
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        // Updated path to match your Django router: router.register(r'profiles', ...)
        Uri.parse("$baseUrl/accounts/profiles/me/"), 
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handles if Django returns a list [profile] or a single object {profile}
        if (data is List && data.isNotEmpty) return data[0];
        if (data is Map<String, dynamic>) return data;
        return {};
      }
      throw Exception("Profile Not Found: ${response.statusCode}");
    } catch (e) {
      throw Exception("Profile fetch failed: $e");
    }
  }
}