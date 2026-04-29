import 'package:flutter/material.dart';
import '../../services/candidate_api.dart';

class JobDetail extends StatefulWidget {
  final Map job;

  const JobDetail({super.key, required this.job});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  final api = CandidateApi();
  bool loading = false;

  void apply() async {
    setState(() => loading = true);

    await api.applyJob(widget.job['id']);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Applied Successfully")),
    );

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      appBar: AppBar(title: Text(job['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job['description']),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : apply,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Apply"),
            ),
          ],
        ),
      ),
    );
  }
}