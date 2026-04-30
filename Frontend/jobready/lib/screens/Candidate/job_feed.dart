import 'package:flutter/material.dart';
import 'package:jobready/services/candidate_api.dart';

class JobFeed extends StatefulWidget {
  const JobFeed({super.key});

  @override
  State<JobFeed> createState() => _JobFeedState();
}

class _JobFeedState extends State<JobFeed> {
  late Future jobs;

  @override
  void initState() {
    super.initState();
    jobs = CandidateApi.getJobs(); // ✅ FIXED
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jobs")),
      body: FutureBuilder(
        future: jobs,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data as List;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index]['title'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}