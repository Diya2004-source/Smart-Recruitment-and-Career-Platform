import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/employer_api.dart';

class JobApplicants extends StatefulWidget {
  final int jobId;
  final String jobTitle;
  const JobApplicants({super.key, required this.jobId, required this.jobTitle});

  @override
  State<JobApplicants> createState() => _JobApplicantsState();
}

class _JobApplicantsState extends State<JobApplicants> {
  final Color orange = const Color(0xFFFF8C00);
  late Future<List<dynamic>> _applicantsFuture;

  @override
  void initState() {
    super.initState();
    _fetchApplicants();
  }

  void _fetchApplicants() {
    setState(() {
      _applicantsFuture = EmployerApi.getApplications(jobId: widget.jobId);
    });
  }

  Future<void> _updateStatus(int id, String status) async {
    try {
      await EmployerApi.updateApplicationStatus(id, status);
      _fetchApplicants();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Candidate $status")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update status")));
    }
  }

  // Helper for URL launching
  Future<void> _makeAction(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Applicants: ${widget.jobTitle}"),
        backgroundColor: orange,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _applicantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: orange));
          }
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (snapshot.data == null || snapshot.data!.isEmpty) return const Center(child: Text("No applicants found."));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final app = snapshot.data![index];
              final candidate = app['candidate_details'] ?? {};

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(candidate['full_name'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Status: ${app['status']}"),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone, color: Colors.green),
                            onPressed: () => _makeAction("tel:${candidate['phone']}"),
                          ),
                          IconButton(
                            icon: const Icon(Icons.message, color: Colors.blue),
                            onPressed: () => _makeAction("sms:${candidate['phone']}"),
                          ),
                          TextButton.icon(
                            icon: Icon(Icons.check_circle, color: orange),
                            label: Text("Shortlist", style: TextStyle(color: orange)),
                            onPressed: () => _updateStatus(app['id'], "Shortlisted"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}