import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session.dart';
import 'package:flutter/foundation.dart';

class EmployerApi {
  // Use 10.0.2.2 for Android Emulator bridge
  static const String baseUrl = "http://10.0.2.2:8000/api";

  static Future<Map<String, String>> _headers() async {
    final token = await Session.getToken();
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  static List<dynamic> _parseList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data.containsKey("results")) return data["results"];
    return [];
  }

  // ================= GET JOBS =================
  static Future<List<dynamic>> getJobs() async {
    final response = await http.get(
      Uri.parse("$baseUrl/jobs/jobs/"), 
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return _parseList(jsonDecode(response.body));
    }
    return [];
  }

  // ================= CREATE JOB =================
  static Future<void> createJob(Map<String, dynamic> jobData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/jobs/jobs/"), 
      headers: await _headers(),
      body: jsonEncode({
        "title": jobData['title'],
        "company_name": jobData['company_name'] ?? "Independent", 
        "description": jobData['description'],
        "location": jobData['location'],
        "required_skills": jobData['required_skills'], 
        "is_active": true,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      debugPrint("Create Job Error: ${response.body}");
      throw Exception("Failed to create job: ${response.statusCode}");
    }
  }

  // ================= APPLICATIONS =================
  static Future<List<dynamic>> getApplications({int? jobId}) async {
    String url = "$baseUrl/jobs/applications/"; 
    if (jobId != null) url += "?job=$jobId";

    final response = await http.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return _parseList(jsonDecode(response.body));
    }
    return [];
  }

  // ================= UPDATED STATUS & MESSAGE =================
  // This triggers the @action detail_route in Django to update status and send a message
  static Future<void> updateApplication(int id, String status, String message) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/jobs/applications/$id/update_application/"), 
      headers: await _headers(),
      body: jsonEncode({
        "status": status,
        "message": message 
      }),
    );

    if (response.statusCode != 200) {
      debugPrint("Update Application Error: ${response.body}");
      throw Exception("Update Failed: ${response.statusCode}");
    }
  }
  
  // ================= SIMPLE STATUS UPDATE =================
  static Future<void> updateApplicationStatus(int id, String status) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/jobs/applications/$id/"), 
      headers: await _headers(),
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode != 200) {
      debugPrint("Status Update Error: ${response.body}");
      throw Exception("Update Failed: ${response.statusCode}");
    }
  }

  // ================= REPORT GENERATION =================
  static Future<void> generateReport() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/accounts/admin/report/"), 
        headers: await _headers(),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to generate report: ${response.body}");
      }
    } catch (e) {
      throw Exception("Report Generation Error: $e");
    }
  }
}