import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployerApi {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<List> getJobs(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/jobs/listings/"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(res.body);
  }

  Future<List> getApplications(String token) async {
    final res = await http.get(
      Uri.parse("$baseUrl/jobs/applications/"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(res.body);
  }

  Future<void> createJob(String token, Map data) async {
    await http.post(
      Uri.parse("$baseUrl/jobs/listings/"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
  }
}