import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session.dart';

class CandidateApi {
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
  static List<dynamic> _parseList(dynamic data) {
    if (data == null) return [];

    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      if (data.containsKey("results")) return data["results"];
      if (data.containsKey("data")) return data["data"];
    }

    return [];
  }

  // ================= GET JOBS (FIXED) =================
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

      // IMPORTANT DEBUG
      throw Exception("Jobs API Error: ${response.statusCode} ${response.body}");
    } catch (e) {
      throw Exception("Jobs fetch failed: $e");
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

      throw Exception(
        "Applications API Error: ${response.statusCode} ${response.body}",
      );
    } catch (e) {
      throw Exception("Applications fetch failed: $e");
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

  // ================= PROFILE (FIXED ENDPOINT) =================
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse("$baseUrl/accounts/candidateprofile/me/"),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is List && data.isNotEmpty) return data[0];
      if (data is Map<String, dynamic>) return data;

      return {};
    }

    throw Exception("Profile API Error: ${response.body}");
  }
}