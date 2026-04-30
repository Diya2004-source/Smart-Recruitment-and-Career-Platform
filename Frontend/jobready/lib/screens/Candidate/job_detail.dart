import 'package:flutter/material.dart';
import 'package:jobready/services/candidate_api.dart';

class JobDetail extends StatelessWidget {
  final int jobId;

  const JobDetail({super.key, required this.jobId});

  Future<void> applyJob(BuildContext context) async {
    await CandidateApi.applyJob(jobId); // ✅ FIXED

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Job Applied Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Job Details")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => applyJob(context),
          child: const Text("Apply"),
        ),
      ),
    );
  }
}