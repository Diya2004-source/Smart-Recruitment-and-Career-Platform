import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JobPostingsPage extends StatefulWidget {
  final String token;
  const JobPostingsPage({super.key, required this.token});

  @override
  State<JobPostingsPage> createState() => _JobPostingsPageState();
}

class _JobPostingsPageState extends State<JobPostingsPage> {
  List jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllJobs();
  }

  Future<void> fetchAllJobs() async {
    // Replace with your actual Django API endpoint for all job listings
    final url = Uri.parse('http://10.0.2.2:8000/api/accounts/admin/all-jobs/');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Adjust based on your API response structure
          jobs = data is List ? data : (data['jobs'] ?? []);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Job Postings"),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : jobs.isEmpty
              ? const Center(child: Text("No active job postings found."))
              : RefreshIndicator(
                  onRefresh: fetchAllJobs,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(job['title'] ?? "Untitled Job",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${job['company_name']} • ${job['location']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              // Add delete/deactivation logic here
                            },
                          ),
                          onTap: () {
                            // Logic to view full details
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}