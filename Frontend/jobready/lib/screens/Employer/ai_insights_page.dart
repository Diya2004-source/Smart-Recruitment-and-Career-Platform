import 'package:flutter/material.dart';

class AIInsightsPage extends StatelessWidget {
  const AIInsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Talent Insights"), backgroundColor: const Color(0xFFFF8C00)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _insightCard("Candidate Matching", "92% of your Python Intern applicants meet 8/10 core requirements.", Icons.psychology),
          _insightCard("Market Trends", "Python Developers in Rajkot are currently seeing a 15% increase in demand.", Icons.trending_up),
          _insightCard("Skill Gap Analysis", "Consider adding 'Django' as a required skill to filter higher-quality candidates.", Icons.lightbulb),
        ],
      ),
    );
  }

  Widget _insightCard(String title, String desc, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF8C00)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
      ),
    );
  }
}