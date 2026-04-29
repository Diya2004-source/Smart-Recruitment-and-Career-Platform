import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'session.dart';

class CandidateApi {
  final String baseUrl = "http://10.0.2.2:8000/api";

  // ================= HEADERS =================
  Future<Map<String, String>> _headers() async {
    final token = await Session.getToken();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // ================= GET JOBS =================
  Future<List> getJobs() async {
    final res = await http.get(
      Uri.parse("$baseUrl/jobs/"),
      headers: await _headers(),
    );

    return jsonDecode(res.body);
  }

  // ================= APPLY JOB =================
  Future<void> applyJob(int jobId) async {
    await http.post(
      Uri.parse("$baseUrl/applications/"),
      headers: await _headers(),
      body: jsonEncode({
        "job": jobId,
      }),
    );
  }

  // ================= MY APPLICATIONS =================
  Future<List> getApplications() async {
    final res = await http.get(
      Uri.parse("$baseUrl/applications/my/"),
      headers: await _headers(),
    );

    return jsonDecode(res.body);
  }

  // ================= PROFILE =================
  Future<Map> getProfile() async {
    final res = await http.get(
      Uri.parse("$baseUrl/profile/"),
      headers: await _headers(),
    );

    return jsonDecode(res.body);
  }

  // ================= UPLOAD RESUME =================
  Future<void> uploadResume(File file) async {
    final token = await Session.getToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/profile/upload-resume/"),
    );

    request.headers['Authorization'] = "Bearer $token";

    request.files.add(
      await http.MultipartFile.fromPath(
        'resume_file',
        file.path,
      ),
    );

    await request.send();
  }
}