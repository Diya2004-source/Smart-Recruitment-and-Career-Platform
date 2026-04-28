import 'package:flutter/material.dart';
import '../../services/employer_api.dart';
import '../../services/session.dart';
import 'add_job.dart';
import 'jobs_list.dart';
import 'applications_page.dart';

class employerdashboard extends StatefulWidget {
  const employerdashboard({super.key});

  @override
  State<employerdashboard> createState() => _employerdashboardState();
}

class _employerdashboardState extends State<employerdashboard> {
  final EmployerApi api = EmployerApi();

  List<Map<String, dynamic>> jobs = [];
  List<Map<String, dynamic>> apps = [];
  bool loading = true;

  final Color brandOrange = const Color(0xFFFF8C00);

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // ================= FETCH DATA =================
  Future<void> fetchData() async {
    if (!mounted) return;

    setState(() => loading = true);

    try {
      final jobData = await api.getJobs();
      final appData = await api.getApplications();

      jobs = List<Map<String, dynamic>>.from(jobData ?? []);
      apps = List<Map<String, dynamic>>.from(appData ?? []);
    } catch (e) {
      debugPrint("Dashboard Error: $e");
      jobs = [];
      apps = [];
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  // ================= ADD JOB + REFRESH =================
  Future<void> goToAddJob() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddJob()),
    );

    if (result == true) {
      fetchData(); // refresh after job added
    }
  }

  // ================= STATS CARD =================
  Widget statCard(String title, int value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [brandOrange, brandOrange.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              value.toString(),
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
  Widget jobCard(Map<String, dynamic> job) {
    final rawSkills = job["required_skills"];

    List<String> skills = [];

    if (rawSkills is List) {
      skills = rawSkills.map((e) => e.toString()).toList();
    } else if (rawSkills != null) {
      skills = [rawSkills.toString()];
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job["title"]?.toString() ?? "No Title",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(job["location"]?.toString() ?? "No Location"),
          const SizedBox(height: 6),
          Text(
            "Skills: ${skills.join(", ")}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ================= BUTTON STYLE =================
  ButtonStyle primaryBtn() {
    return ElevatedButton.styleFrom(
      backgroundColor: brandOrange,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (Session.token == null) {
      return const Scaffold(
        body: Center(child: Text("Login required")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employer Dashboard"),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: brandOrange),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: brandOrange,
              child: const Text(
                "Employer Panel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            ListTile(
              title: const Text("Dashboard"),
              onTap: () => Navigator.pop(context),
            ),

            ListTile(
              title: const Text("Jobs"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JobsList()),
                );
              },
            ),

            ListTile(
              title: const Text("Applications"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ApplicationsPage()),
                );
              },
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
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        statCard("Jobs", jobs.length, Icons.work),
                        const SizedBox(width: 10),
                        statCard("Applications", apps.length, Icons.people),
                      ],
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton.icon(
                      style: primaryBtn(),
                      icon: const Icon(Icons.add),
                      label: const Text("Post New Job"),
                      onPressed: goToAddJob,
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Recent Jobs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    jobs.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("No jobs posted yet"),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: jobs.length > 5 ? 5 : jobs.length,
                            itemBuilder: (c, i) => jobCard(jobs[i]),
                          ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: primaryBtn(),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const JobsList(),
                          ),
                        );
                      },
                      child: const Text("View All Jobs"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}