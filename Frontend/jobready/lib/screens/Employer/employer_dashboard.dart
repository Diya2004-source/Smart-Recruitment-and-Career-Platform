import 'package:flutter/material.dart';
import '../../services/employer_api.dart';
import '../../services/session.dart';
import 'add_job.dart';
import 'jobs_list.dart';

class employerdashboard extends StatefulWidget {
  const employerdashboard({super.key});

  @override
  State<employerdashboard> createState() => _employerdashboardState();
}

class _employerdashboardState extends State<employerdashboard> {
  List jobs = [];
  List applications = [];
  bool loading = true;

  final Color orange = const Color(0xFFFF8C00);

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);

    try {
      jobs = await EmployerApi.getJobs();

      applications = [];

      for (var job in jobs) {
        final jobApps =
            await EmployerApi.getApplications(jobId: job['id']);
        applications.addAll(jobApps);
      }
    } catch (e) {
      debugPrint("Dashboard Error: $e");
    }

    setState(() => loading = false);
  }

  Widget statCard(String title, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [orange, orange.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              "$count",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget jobCard(Map job) {
    int jobId = job['id'];

    int applicantCount =
        applications.where((a) => a['job'] == jobId).length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        title: Text(job['title'] ?? "No Title"),
        subtitle: Text(job['location'] ?? ""),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$applicantCount",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const Text("Applicants", style: TextStyle(fontSize: 12)),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobsList(selectedJobId: jobId),
            ),
          );
        },
      ),
    );
  }

  Future<void> openAddJob() async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddJob()),
    );

    if (res == true) load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employer Dashboard"),
        backgroundColor: orange,
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: orange,
              child: const Text("Employer Panel",
                  style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Session.logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              },
            )
          ],
        ),
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
                      statCard("Jobs", jobs.length, Icons.work),
                      const SizedBox(width: 10),
                      statCard(
                          "Applications", applications.length, Icons.people),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: openAddJob,
                    icon: const Icon(Icons.add),
                    label: const Text("Post Job"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: orange,
                        minimumSize: const Size(double.infinity, 50)),
                  ),

                  const SizedBox(height: 20),

                  const Text("Your Jobs",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  jobs.isEmpty
                      ? const Center(child: Text("No jobs posted"))
                      : Column(
                          children:
                              jobs.map((job) => jobCard(job)).toList(),
                        )
                ],
              ),
            ),
    );
  }
}