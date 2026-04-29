import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session.dart';

class EmployerApi {
  final String baseUrl = "http://10.0.2.2:8000/api/jobs";

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Session.token}",
      };

  // GET JOBS (Recruiter gets only their jobs)
  Future<List> getJobs() async {
    final res = await http.get(
      Uri.parse("$baseUrl/listings/"),
      headers: headers,
    );

    return jsonDecode(res.body);
  }

  //  CREATE JOB
  Future createJob(Map data) async {
    final res = await http.post(
      Uri.parse("$baseUrl/listings/"),
      headers: headers,
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);
  }

  //  GET APPLICATIONS BY JOB
  Future<List> getApplications(int jobId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/applications/?job=$jobId"),
      headers: headers,
    );

    return jsonDecode(res.body);
  }
}