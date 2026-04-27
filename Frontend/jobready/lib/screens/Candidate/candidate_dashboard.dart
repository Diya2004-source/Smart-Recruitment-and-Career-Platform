import 'package:flutter/material.dart';

class jobseekerdashboard extends StatefulWidget {
  const jobseekerdashboard({super.key});

  @override
  State<jobseekerdashboard> createState() => _jobseekerdashboardState();
}

class _jobseekerdashboardState extends State<jobseekerdashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidate Dashboard"),
      ),
      body: const Center(
        child: Text(
          "Welcome to the Candidate Dashboard!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}