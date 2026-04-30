import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session.dart';

class CandidateApi {
  static String baseUrl = "http://10.0.2.2:8000/api";

  // ================= HEADERS =================
  static Future<Map<String, String>> _headers() async {
    final token = await Session.getToken(); // 🔴 FIXED

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  // ================= SAFE PARSER =================
  static List<dynamic> _parseListResponse(dynamic data) {
    if (data is List) return data;

    if (data is Map && data.containsKey("results")) {
      return data["results"];
    }

    return [];
  }

  // ================= JOBS =================
  static Future<List<dynamic>> getJobs() async {
    final response = await http.get(
      Uri.parse("$baseUrl/jobs/"),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return _parseListResponse(jsonDecode(response.body));
    } else {
      throw Exception("Job API Failed (${response.statusCode})");
    }
  }

  // ================= APPLICATIONS =================
  static Future<List<dynamic>> getApplications() async {
    final response = await http.get(
      Uri.parse("$baseUrl/applications/"),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return _parseListResponse(jsonDecode(response.body));
    } else {
      throw Exception("Applications API Failed (${response.statusCode})");
    }
  }

  // ================= APPLY JOB =================
  static Future<void> applyJob(int jobId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/applications/"),
      headers: await _headers(),
      body: jsonEncode({"job": jobId}), // 🔴 MUST BE INT
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    } else {
      throw Exception(jsonDecode(response.body).toString());
    }
  }

  // ================= PROFILE =================
  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse("$baseUrl/candidateprofile/me/"),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Profile API Failed (${response.statusCode})");
    }
  }
}