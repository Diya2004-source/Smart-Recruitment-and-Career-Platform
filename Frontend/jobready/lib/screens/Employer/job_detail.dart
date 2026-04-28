import 'package:flutter/material.dart';
import '../../services/employer_api.dart';

class JobDetail extends StatefulWidget {
  final Map job;
  const JobDetail({super.key, required this.job});

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  final api = EmployerApi();
  List apps = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final all = await api.getApplications();

    apps = all.where((a) => a["job"] == widget.job["id"]).toList();

    setState(() => loading = false);
  }

  Widget statusChip(String status) {
    Color c = Colors.grey;

    if (status == "SHORTLISTED") c = Colors.green;
    if (status == "REJECTED") c = Colors.red;

    return Chip(label: Text(status), backgroundColor: c.withOpacity(0.2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.job["title"])),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: apps.length,
              itemBuilder: (c, i) {
                final a = apps[i];

                return Card(
                  child: ListTile(
                    title: Text(a["candidate_username"]),
                    subtitle: Text("Score: ${a["match_score"].toStringAsFixed(1)}%"),
                    trailing: statusChip(a["status"]),

                    onTap: () => openDialog(a),
                  ),
                );
              },
            ),
    );
  }

  void openDialog(Map app) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(app["candidate_username"]),
        content: Text("Match Score: ${app["match_score"]}%"),

        actions: [
          TextButton(
            onPressed: () async {
              await api.updateApplicationStatus(app["id"], "SHORTLISTED");
              Navigator.pop(context);
              load();
            },
            child: const Text("Shortlist"),
          ),
          TextButton(
            onPressed: () async {
              await api.updateApplicationStatus(app["id"], "REJECTED");
              Navigator.pop(context);
              load();
            },
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }
}