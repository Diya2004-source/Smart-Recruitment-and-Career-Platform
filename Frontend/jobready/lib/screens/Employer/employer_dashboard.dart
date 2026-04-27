import 'package:flutter/material.dart';

class employerdashboard extends StatefulWidget {
  const employerdashboard({super.key});

  @override
  State<employerdashboard> createState() => _employerdashboardState();
}

class _employerdashboardState extends State<employerdashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employer Dashboard"),
      ),
      body: const Center(
        child: Text(
          "Welcome to the Employer Dashboard!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}