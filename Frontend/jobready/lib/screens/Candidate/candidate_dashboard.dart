import 'package:flutter/material.dart';
import 'package:jobready/services/candidate_api.dart';

class jobseekerdashboard extends StatefulWidget {
  const jobseekerdashboard({super.key});

  @override
  State<jobseekerdashboard> createState() => _jobseekerdashboardState();
}

class _jobseekerdashboardState extends State<jobseekerdashboard> {
  List jobs = [];
  List applications = [];
  bool loading = true;

  final Color primary = const Color(0xFFFF8C00);

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);

    try {
      final jobRes = await CandidateApi.getJobs();
      final appRes = await CandidateApi.getApplications();

      setState(() {
        jobs = jobRes;
        applications = appRes;
      });

      debugPrint("✅ JOBS LOADED: ${jobs.length}");
      debugPrint("RAW: $jobs");
    } catch (e) {
      debugPrint("❌ LOAD ERROR: $e");
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  Future<void> apply(int id) async {
    try {
      await CandidateApi.applyJob(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Applied successfully")),
      );

      load();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget jobCard(dynamic job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job["title"] ?? "No Title",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(job["location"] ?? "Unknown"),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              onPressed: () => apply(job["id"]),
              child: const Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text("Candidate Dashboard"),
        backgroundColor: primary,
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
                      _stat("Applied", applications.length),
                      _stat("Jobs", jobs.length),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Recommended Jobs",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  jobs.isEmpty
                      ? const Center(child: Text("No jobs found"))
                      : Column(
                          children: jobs.map((j) => jobCard(j)).toList(),
                        ),
                ],
              ),
            ),
    );
  }

  Widget _stat(String title, int count) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text("$count",
                style: const TextStyle(color: Colors.white, fontSize: 20)),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}