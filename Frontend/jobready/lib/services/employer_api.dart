import 'dart:convert';
import 'package:http/http.dart' as http;
import 'session.dart';

class EmployerApi {
  final base = "http://10.0.2.2:8000/api";

  Map<String, String> get headers => {
        "Authorization": "Bearer ${Session.token}",
        "Content-Type": "application/json",
      };

  Future<List> getJobs() async {
    final res = await http.get(
      Uri.parse("$base/jobs/listings/"),
      headers: headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return [];
  }

  Future<List> getApplications() async {
    final res = await http.get(
      Uri.parse("$base/jobs/applications/"),
      headers: headers,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    return [];
  }

  Future<void> createJob(Map data) async {
    await http.post(
      Uri.parse("$base/jobs/listings/"),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  Future<void> updateApplicationStatus(int id, String status) async {
    await http.patch(
      Uri.parse("$base/jobs/applications/$id/"),
      headers: headers,
      body: jsonEncode({"status": status}),
    );
  }
}