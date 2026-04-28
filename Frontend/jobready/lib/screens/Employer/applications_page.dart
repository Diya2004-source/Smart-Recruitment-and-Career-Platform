import 'package:flutter/material.dart';
import '../../services/employer_api.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  final api = EmployerApi();
  List apps = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    apps = await api.getApplications();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Applications")),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: apps.length,
              itemBuilder: (c, i) {
                final a = apps[i];

                return Card(
                  child: ListTile(
                    title: Text(a["candidate_username"]),
                    subtitle: Text(a["job_title"]),
                    trailing: Text("${a["match_score"]}%"),
                  ),
                );
              },
            ),
    );
  }
}