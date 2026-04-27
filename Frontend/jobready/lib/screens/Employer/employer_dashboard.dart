import 'package:flutter/material.dart';
import '../../services/employer_api.dart';
import 'theme/colors.dart';

class employerdashboard extends StatefulWidget {
  final String token;

  const employerdashboard({super.key, required this.token});

  @override
  State<employerdashboard> createState() => _employerdashboardState();
}

class _employerdashboardState extends State<employerdashboard> {
  final api = EmployerApi();

  bool loading = true;

  List jobs = [];
  List applications = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      jobs = await api.getJobs(widget.token);
      applications = await api.getApplications(widget.token);

      setState(() => loading = false);
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Widget statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          Text(title),
        ],
      ),
    );
  }

  Widget jobCard(Map j) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(j["title"] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(j["location"] ?? "No location"),
          const SizedBox(height: 5),
          Text("Skills: ${j["required_skills"] ?? []}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Recruiter Dashboard"),
        iconTheme: const IconThemeData(color: Colors.orange),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [

                  Row(
                    children: [
                      Expanded(
                        child: statCard("Jobs", "${jobs.length}", Icons.work),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: statCard("Applications",
                            "${applications.length}", Icons.people),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/addjob",
                            arguments: widget.token);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Post New Job"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Recent Jobs",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: jobs.isEmpty
                        ? const Center(child: Text("No jobs yet"))
                        : ListView.builder(
                            itemCount: jobs.length,
                            itemBuilder: (c, i) => jobCard(jobs[i]),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}