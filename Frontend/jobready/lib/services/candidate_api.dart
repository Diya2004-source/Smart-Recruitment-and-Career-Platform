import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session.dart'; 
import 'package:flutter/foundation.dart';

class CandidateApi {
  // Use 10.0.2.2 for Android Emulator, 127.0.0.1 for iOS/Web
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
      if (data.containsKey("results")) return data["results"] ?? [];
      if (data.containsKey("data")) return data["data"] ?? [];
    }
    return [];
  }

  // ================= GET PROFILE =================
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/accounts/profiles/me/"), 
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // If DRF returns a list, take the first profile object
        if (data is List && data.isNotEmpty) return data[0];
        if (data is Map<String, dynamic>) return data;
        return {};
      } else {
        debugPrint("Profile Error: ${response.statusCode}");
        return {};
      }
    } catch (e) {
      debugPrint("Profile Fetch Error: $e");
      return {};
    }
  }

  // ================= GET JOBS =================
  static Future<List<dynamic>> getJobs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/jobs/jobs/'),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return _parseList(decodedData);
      }
      return [];
    } catch (e) {
      debugPrint("Jobs Network Error: $e");
      return [];
    }
  }

  // ================= GET APPLICATIONS =================
  static Future<List<dynamic>> getApplications() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/jobs/applications/"),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        return _parseList(jsonDecode(response.body));
      }
      return [];
    } catch (e) {
      debugPrint("Applications Fetch Error: $e");
      return [];
    }
  }

  // ================= APPLY JOB =================
  static Future<void> applyJob(int jobId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/jobs/applications/"), 
        headers: await _headers(),
        body: jsonEncode({"job": jobId}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception("Server Error (${response.statusCode})");
      }
    } catch (e) {
      rethrow; 
    }
  }
}