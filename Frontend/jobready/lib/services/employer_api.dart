// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'session.dart';

// class EmployerApi {
//   static String baseUrl = "http://10.0.2.2:8000/api";

//   // ================= HEADERS =================
//   static Future<Map<String, String>> _headers() async {
//     final token = await Session.getToken();

//     if (token == null || token.isEmpty) {
//       throw Exception("User not logged in");
//     }

//     return {
//       "Authorization": "Bearer $token",
//       "Content-Type": "application/json",
//     };
//   }

//   // ================= RESPONSE PARSER =================
//   static dynamic _decode(http.Response response) {
//     try {
//       final data = jsonDecode(response.body);

//       if (data is Map && data.containsKey("results")) {
//         return data["results"];
//       }

//       return data;
//     } catch (_) {
//       return [];
//     }
//   }

//   // ================= GET JOBS =================
//   static Future<List<dynamic>> getJobs() async {
//     final response = await http.get(
//       Uri.parse("$baseUrl/jobs/jobs/"), // 🔥 FIXED PATH
//       headers: await _headers(),
//     );

//     if (response.statusCode == 200) {
//       final data = _decode(response);
//       return data is List ? data : [];
//     }

//     throw Exception("Failed to load jobs: ${response.body}");
//   }

//   // ================= CREATE JOB =================
//   static Future<void> createJob(Map<String, dynamic> jobData) async {
//     final response = await http.post(
//       Uri.parse("$baseUrl/jobs/jobs/"), // 🔥 FIXED PATH
//       headers: await _headers(),
//       body: jsonEncode(jobData),
//     );

//     if (response.statusCode != 201 && response.statusCode != 200) {
//       throw Exception(response.body);
//     }
//   }

//   // ================= APPLICATIONS =================
//   static Future<List<dynamic>> getApplications({int? jobId}) async {
//     String url = "$baseUrl/jobs/applications/";

//     if (jobId != null) {
//       url += "?job=$jobId";
//     }

//     final response = await http.get(
//       Uri.parse(url),
//       headers: await _headers(),
//     );

//     if (response.statusCode == 200) {
//       final data = _decode(response);
//       return data is List ? data : [];
//     }

//     throw Exception("Failed to load applications");
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session.dart';

class EmployerApi {
  static String baseUrl = "http://10.0.2.2:8000/api";

  // ================= HEADERS =================
  static Future<Map<String, String>> _headers() async {
    final token = await Session.getToken();

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  // ================= SAFE PARSER =================
  static List<dynamic> _parseList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data.containsKey("results")) return data["results"];
    return [];
  }

  // ================= GET JOBS =================
  static Future<List<dynamic>> getJobs() async {
    final response = await http.get(
      Uri.parse("$baseUrl/jobs/"),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return _parseList(jsonDecode(response.body));
    }

    throw Exception("Failed to load jobs: ${response.body}");
  }

  // ================= CREATE JOB =================
  static Future<void> createJob(Map<String, dynamic> jobData) async {
    final response = await http.post(
      Uri.parse("$baseUrl/jobs/"),
      headers: await _headers(),
      body: jsonEncode(jobData),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    }

    throw Exception("Failed to create job: ${response.body}");
  }

  // ================= APPLICATIONS =================
  static Future<List<dynamic>> getApplications({int? jobId}) async {
    String url = "$baseUrl/applications/";

    if (jobId != null) {
      url += "?job=$jobId";
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      return _parseList(jsonDecode(response.body));
    }

    throw Exception("Failed to load applications: ${response.body}");
  }
}