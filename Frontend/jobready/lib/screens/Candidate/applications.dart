import 'package:flutter/material.dart';
import 'package:jobready/services/candidate_api.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  late Future applications;

  @override
  void initState() {
    super.initState();
    applications = CandidateApi.getApplications(); // ✅ FIXED
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Applications")),
      body: FutureBuilder(
        future: applications,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data as List;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index]['job_title'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}