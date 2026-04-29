import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session.dart';

class CandidateApi {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Session.token}",
      };

  // ================= PROFILE =================
  Future<Map<String, dynamic>> getProfile() async {
    final res = await http.get(
      Uri.parse("$baseUrl/accounts/profiles/me/"),
      headers: headers,
    );

    return jsonDecode(res.body);
  }

  // ================= JOBS =================
  Future<List> getJobs() async {
    final res = await http.get(
      Uri.parse("$baseUrl/jobs/"),
      headers: headers,
    );

    return jsonDecode(res.body);
  }

  // ================= APPLY JOB =================
  Future<Map<String, dynamic>> applyJob(int jobId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/jobs/$jobId/apply/"),
      headers: headers,
    );

    return jsonDecode(res.body);
  }

  // ================= APPLICATIONS =================
  Future<List> getApplications() async {
    final res = await http.get(
      Uri.parse("$baseUrl/jobs/my-applications/"),
      headers: headers,
    );

    return jsonDecode(res.body);
  }

  // ================= UPLOAD RESUME =================
  Future uploadResume(String filePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/accounts/upload-resume/"),
    );

    request.headers.addAll({
      "Authorization": "Bearer ${Session.token}",
    });

    request.files.add(await http.MultipartFile.fromPath(
      'resume',
      filePath,
    ));

    final res = await request.send();
    return res.statusCode == 200;
  }
}