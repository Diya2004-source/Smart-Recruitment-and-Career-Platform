import 'package:flutter/material.dart';
import '../../services/candidate_api.dart';

class Applications extends StatefulWidget {
  const Applications({super.key});

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  final api = CandidateApi();
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
      appBar: AppBar(title: const Text("My Applications")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: apps.length,
              itemBuilder: (c, i) {
                final app = apps[i];

                return Card(
                  child: ListTile(
                    title: Text(app['job']['title']),
                    subtitle: Text("Status: ${app['status']}"),
                  ),
                );
              },
            ),
    );
  }
}