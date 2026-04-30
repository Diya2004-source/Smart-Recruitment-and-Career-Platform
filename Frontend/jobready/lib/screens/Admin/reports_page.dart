import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportsPage extends StatefulWidget {
  final String token;
  const ReportsPage({super.key, required this.token});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool isLoading = true;
  Map<String, dynamic> reportData = {
    "total_users": 0,
    "active_jobs": 0,
    "candidates": 0,
    "recruiters": 0,
  };

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    // Reusing your admin dashboard endpoint which contains these stats
    final url = Uri.parse('http://10.0.2.2:8000/api/accounts/admin/dashboard/');
    
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          reportData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load reports")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("System Reports", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchReportData,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : RefreshIndicator(
              onRefresh: fetchReportData,
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildReportCard("Total Users", reportData["total_users"].toString(), Icons.people),
                  _buildReportCard("Active Jobs", reportData["active_jobs"].toString(), Icons.business_center),
                  _buildReportCard("Candidates", reportData["candidates"].toString(), Icons.school),
                  _buildReportCard("Recruiters", reportData["recruiters"].toString(), Icons.work),
                ],
              ),
            ),
    );
  }

  Widget _buildReportCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange, size: 40),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}