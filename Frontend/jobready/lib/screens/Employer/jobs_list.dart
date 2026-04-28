import 'package:flutter/material.dart';
import '../../services/employer_api.dart';
import 'job_detail.dart';

class JobsList extends StatefulWidget {
  const JobsList({super.key});

  @override
  State<JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  final api = EmployerApi();
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
                final j = jobs[i];

                return Card(
                  child: ListTile(
                    title: Text(j["title"]),
                    subtitle: Text(j["location"] ?? ""),
                    trailing: Icon(
                      j["is_active"] ? Icons.check_circle : Icons.cancel,
                      color: j["is_active"] ? Colors.green : Colors.red,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JobDetail(job: j),
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