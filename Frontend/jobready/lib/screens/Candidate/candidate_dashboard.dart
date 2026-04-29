import 'package:flutter/material.dart';
import '../../services/candidate_api.dart';
import '../../services/session.dart';

class jobseekerdashboard extends StatefulWidget {
  const jobseekerdashboard({super.key});

  @override
  State<jobseekerdashboard> createState() => _jobseekerdashboardState();
}

class _jobseekerdashboardState extends State<jobseekerdashboard> {
  final api = CandidateApi();

  Map profile = {};
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
      profile = await api.getProfile();
      jobs = await api.getJobs(); // recommended jobs
      applications = await api.getApplications();
    } catch (e) {
      debugPrint("Load error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load dashboard")),
      );
    }

    setState(() => loading = false);
  }

  // ================= LOGOUT =================
  void logout() {
    Session.logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (_) => false,
    );
  }

  // ================= STATS =================
  Widget statCard(String title, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [orange, orange.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              "$count",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // ================= MATCH COLOR =================
  Color getMatchColor(double score) {
    if (score >= 75) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  // ================= JOB CARD =================
  Widget jobCard(Map job) {
    double match = (job['match_score'] ?? 0).toDouble();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: ListTile(
        title: Text(
          job['title'] ?? "",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job['location'] ?? ""),
            const SizedBox(height: 5),

            // MATCH %
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: getMatchColor(match).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${match.toStringAsFixed(0)}% Match",
                style: TextStyle(
                  color: getMatchColor(match),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: () {
          // TODO: Job detail screen
        },
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    int applied = applications.length;
    int shortlisted = applications
        .where((a) => a['status'] == "SHORTLISTED")
        .length;

    List skills = profile['skills']?['tech'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidate Dashboard"),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: orange),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [orange, orange.withOpacity(0.8)],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.person, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "Candidate Panel",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              leading: const Icon(Icons.description),
              title: const Text("My Applications"),
              onTap: () {
                // TODO
              },
            ),

            const Spacer(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: logout,
            ),
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

                  // ================= PROFILE =================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [orange, orange.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile['user']?['username'] ?? "User",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Experience: ${profile['experience_years']} years",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= STATS =================
                  Row(
                    children: [
                      statCard("Applied", applied, Icons.send),
                      const SizedBox(width: 10),
                      statCard("Shortlisted", shortlisted, Icons.star),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ================= SKILLS =================
                  const Text(
                    "Your Skills",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: skills.map((s) {
                      return Chip(
                        label: Text(s.toString()),
                        backgroundColor: orange.withOpacity(0.1),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // ================= JOBS =================
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