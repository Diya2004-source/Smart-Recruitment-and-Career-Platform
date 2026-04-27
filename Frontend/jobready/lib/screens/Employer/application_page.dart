import 'package:flutter/material.dart';
import '../../services/employer_api.dart';

class ApplicantsPage extends StatefulWidget {
  final String token;
  const ApplicantsPage({super.key, required this.token});

  @override
  State<ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends State<ApplicantsPage> {
  final api = EmployerApi();
  List apps = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    apps = await api.getApplications(widget.token);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Applicants")),

      body: ListView.builder(
        itemCount: apps.length,
        itemBuilder: (c, i) {
          final a = apps[i];

          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a["candidate_username"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),

                Text("Job: ${a["job_title"]}"),
                Text("Score: ${a["match_score"]}%"),
                Text("Status: ${a["status"]}"),
              ],
            ),
          );
        },
      ),
    );
  }
}