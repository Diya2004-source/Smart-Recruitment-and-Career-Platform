import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ReportsPage extends StatefulWidget {
  final String token;

  const ReportsPage({super.key, required this.token});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool isLoading = true;

  int total = 0;
  int pending = 0;
  int resolved = 0;

  List<int> monthlyReports = [];

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/api/accounts/admin/dashboard/"),
      headers: {
        "Authorization": "Bearer ${widget.token}",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        total = data["reports"] ?? 0;
        pending = 5;   // replace with backend if available
        resolved = 7;  // replace with backend if available

        // dummy monthly data (replace with backend later)
        monthlyReports = [3, 5, 2, 8, 6, 10];

        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> downloadReport() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/api/accounts/admin/report/"),
      headers: {"Authorization": "Bearer ${widget.token}"},
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/admin_report.pdf");

    await file.writeAsBytes(response.bodyBytes);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports Analytics"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: downloadReport,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchReports,
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ================= SUMMARY =================
                  const Text(
                    "Report Overview",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statBox("Total", total, Colors.blue),
                      _statBox("Pending", pending, Colors.orange),
                      _statBox("Resolved", resolved, Colors.green),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ================= PIE CHART =================
                  const Text(
                    "Status Distribution",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: pending.toDouble(),
                            title: "Pending",
                            color: Colors.orange,
                            radius: 80,
                          ),
                          PieChartSectionData(
                            value: resolved.toDouble(),
                            title: "Resolved",
                            color: Colors.green,
                            radius: 80,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= BAR CHART =================
                  const Text(
                    "Monthly Reports",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        barGroups: monthlyReports
                            .asMap()
                            .entries
                            .map(
                              (e) => BarChartGroupData(
                                x: e.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: e.value.toDouble(),
                                    width: 16,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= DOWNLOAD BUTTON =================
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text("Download Full Report PDF"),
                      onPressed: downloadReport,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _statBox(String title, int value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }
}