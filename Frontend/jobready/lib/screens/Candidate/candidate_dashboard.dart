import 'package:flutter/material.dart';
import 'package:jobready/services/candidate_api.dart';
import 'package:jobready/services/session.dart';
import 'package:jobready/screens/Candidate/resume_upload.dart';

class jobseekerdashboard extends StatefulWidget {
  const jobseekerdashboard({super.key});

  @override
  State<jobseekerdashboard> createState() => _jobseekerdashboardState();
}

class _jobseekerdashboardState extends State<jobseekerdashboard> {
  List jobs = [];
  List applications = [];
  bool loading = true;

  final Color orange = const Color(0xFFFF8C00);

  @override
  void initState() {
    super.initState();
    load();
  }

  // ================= SAFE EXTRACTOR =================
  List _extractList(dynamic data) {
    if (data is List) return data;

    if (data is Map) {
      if (data.containsKey("results")) return data["results"];
      if (data.containsKey("data")) return data["data"];
    }

    return [];
  }

  // ================= LOAD DATA =================
  Future<void> load() async {
    setState(() => loading = true);

    try {
      final jobRes = await CandidateApi.getJobs();
      final appRes = await CandidateApi.getApplications();

      jobs = _extractList(jobRes);
      applications = _extractList(appRes);

      debugPrint("Jobs: ${jobs.length}, Applications: ${applications.length}");
    } catch (e) {
      debugPrint("Dashboard Error: $e");
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  // ================= APPLY JOB =================
  Future<void> applyJob(dynamic jobId) async {
    try {
      final int id = int.parse(jobId.toString());

      await CandidateApi.applyJob(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Applied Successfully")),
      );

      load();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // ================= LOGOUT =================
  void logout() async {
    await Session.logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (_) => false,
    );
  }

  // ================= MENU =================
  PopupMenuButton menu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == "resume") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ResumeUpload()),
          );
        } else if (value == "logout") {
          logout();
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: "resume", child: Text("Upload Resume")),
        PopupMenuItem(value: "logout", child: Text("Logout")),
      ],
    );
  }

  // ================= STATS =================
  Widget statCard(String title, int count) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [orange, orange.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              "$count",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ================= JOB CARD =================
  Widget jobCard(dynamic job) {
    final jobId = job['id'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job['title']?.toString() ?? "No Title",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(job['location']?.toString() ?? "Unknown"),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => applyJob(jobId),
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
              ),
              child: const Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ACTION =================
  Widget action(IconData icon, String label, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: orange),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Job Seeker Dashboard"),
        backgroundColor: orange,
        actions: [menu()],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      statCard("Applied", applications.length),
                      statCard("Saved", 0),
                      statCard("Shortlisted", 0),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        action(Icons.work, "Jobs"),
                        action(Icons.upload_file, "Resume", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ResumeUpload(),
                            ),
                          );
                        }),
                        action(Icons.list, "Applied"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Recommended Jobs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  jobs.isEmpty
                      ? const Center(child: Text("No jobs available"))
                      : Column(
                          children:
                              jobs.map((job) => jobCard(job)).toList(),
                        ),
                ],
              ),
            ),
    );
  }
}