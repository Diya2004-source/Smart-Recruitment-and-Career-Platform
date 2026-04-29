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
  final api = EmployerApi();

  List jobs = [];
  List applications = [];
  bool loading = true;

  final Color orange = const Color(0xFFFF8C00);

  @override
  void initState() {
    super.initState();
    load();
  }

  // ================= LOAD DATA =================
  Future<void> load() async {
    setState(() => loading = true);

    try {
      jobs = await api.getJobs();

      applications = [];

      // 🔥 FIX: since API requires jobId
      for (var job in jobs) {
        final jobApps = await api.getApplications(job['id']);
        applications.addAll(jobApps);
      }
    } catch (e) {
      debugPrint("Load Error: $e");
    }

    setState(() => loading = false);
  }

  // ================= ADD JOB =================
  Future<void> openAddJob() async {
    final res = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddJob()),
    );

    if (res == true) {
      await load();
    }
  }

  // ================= SIDEBAR =================
  Widget drawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: orange,
            child: const Text(
              "Employer Panel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => Navigator.pop(context),
          ),

          ListTile(
            leading: const Icon(Icons.work),
            title: const Text("Jobs"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JobsList()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Applications"),
            onTap: () {},
          ),

          const Spacer(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              Session.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= STATS CARD =================
  Widget statCard(String title, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [orange, orange.withOpacity(0.8)],
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
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ================= JOB CARD =================
  Widget jobCard(Map job) {
    int jobId = job['id'];

    int applicantCount = applications
        .where((a) => a['job'] == jobId)
        .length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: ListTile(
        title: Text(job['title'] ?? "No Title"),
        subtitle: Text(job['location'] ?? "No Location"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$applicantCount",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
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

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),

      appBar: AppBar(
        title: const Text("Employer Dashboard"),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: orange),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [

                  // ================= STATS =================
                  Row(
                    children: [
                      statCard("Jobs", jobs.length, Icons.work),
                      const SizedBox(width: 10),
                      statCard("Applications", applications.length, Icons.people),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ================= ADD JOB =================
                  ElevatedButton.icon(
                    onPressed: openAddJob,
                    icon: const Icon(Icons.add),
                    label: const Text("Post New Job"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Your Jobs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  jobs.isEmpty
                      ? const Center(child: Text("No jobs posted yet"))
                      : Column(
                          children: jobs.map((job) => jobCard(job)).toList(),
                        ),
                ],
              ),
            ),
    );
  }
}