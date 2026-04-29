import 'package:flutter/material.dart';
import '../../services/candidate_api.dart';
import 'job_detail.dart';

class JobFeed extends StatefulWidget {
  const JobFeed({super.key});

  @override
  State<JobFeed> createState() => _JobFeedState();
}

class _JobFeedState extends State<JobFeed> {
  final api = CandidateApi();
  List jobs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    jobs = await api.getJobs();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jobs")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (c, i) {
                final job = jobs[i];

                return Card(
                  child: ListTile(
                    title: Text(job['title']),
                    subtitle: Text(job['location']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetail(job: job),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}