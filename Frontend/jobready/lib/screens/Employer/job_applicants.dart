import 'package:flutter/material.dart';
import '../../services/employer_api.dart';

class JobApplicants extends StatefulWidget {
  final int jobId;

  const JobApplicants({super.key, required this.jobId});

  @override
  State<JobApplicants> createState() => _JobApplicantsState();
}

class _JobApplicantsState extends State<JobApplicants> {
  List applicants = [];
  bool loading = true;

  final Color orange = const Color(0xFFFF8C00);

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data =
          await EmployerApi.getApplications(jobId: widget.jobId);

      if (!mounted) return;

      setState(() {
        applicants = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Widget applicantCard(app) {
    final user = app['candidate'] ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        tileColor: Colors.white,
        leading: CircleAvatar(
          backgroundColor: orange,
          child: Text(
            (user['username'] ?? "U")[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user['username'] ?? "Unknown"),
        subtitle: Text(user['email'] ?? ""),
        trailing: Text(
          "${app['match_score'] ?? 0}%",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Applicants"),
          backgroundColor: orange),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : applicants.isEmpty
              ? const Center(child: Text("No Applicants"))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children:
                      applicants.map((e) => applicantCard(e)).toList(),
                ),
    );
  }
}