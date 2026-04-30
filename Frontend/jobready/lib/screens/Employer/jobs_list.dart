import 'package:flutter/material.dart';
import '../../services/employer_api.dart';
import 'job_applicants.dart';

class JobsList extends StatefulWidget {
  final int? selectedJobId;

  const JobsList({super.key, this.selectedJobId});

  @override
  State<JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  List jobs = [];
  bool loading = true;

  final Color orange = const Color(0xFFFF8C00);

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await EmployerApi.getJobs();

      if (!mounted) return;

      setState(() {
        jobs = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Widget jobCard(job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(job['title']),
        subtitle: Text(job['location'] ?? ""),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobApplicants(jobId: job['id']),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Jobs"), backgroundColor: orange),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: jobs.map((e) => jobCard(e)).toList(),
            ),
    );
  }
}