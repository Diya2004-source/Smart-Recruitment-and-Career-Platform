import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/employer_api.dart';
import 'jobs_list.dart';
import 'add_job.dart';
import 'ai_insights_page.dart'; 
import 'employer_profile.dart'; 

class employerdashboard extends StatefulWidget {
  const employerdashboard({super.key});

  @override
  State<employerdashboard> createState() => _employerdashboardState();
}

class _employerdashboardState extends State<employerdashboard> {
  final Color primaryOrange = const Color(0xFFFF8C00);
  final Color bgWhite = const Color(0xFFFFFFFF);
  final Color surfaceGrey = const Color(0xFFF8F9FA);

  bool _isSidebarOpen = true;
  int _activeJobsCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      final jobs = await EmployerApi.getJobs();
      setState(() {
        _activeJobsCount = jobs.length;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: bgWhite,
        leading: IconButton(
          icon: Icon(_isSidebarOpen ? Icons.menu_open : Icons.menu, color: primaryOrange),
          onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
        ),
        // Logo and Heading Row
        title: Row(
          children: [
            Image.asset('assets/images/Logo.png', height: 30),
            const SizedBox(width: 10),
            Text(
              "Employer Dashboard",
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployerProfilePage())),
            icon: CircleAvatar(
              radius: 18,
              backgroundColor: primaryOrange.withOpacity(0.1),
              child: Icon(Icons.person, color: primaryOrange, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (_isSidebarOpen) _buildSidebar(),
          Expanded(
            child: Container(
              color: surfaceGrey,
              child: _isLoading 
                ? Center(child: CircularProgressIndicator(color: primaryOrange))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Recruitment Overview", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildStatsRow(),
                        const SizedBox(height: 16),
                        _buildChartSection(),
                        const SizedBox(height: 16),
                        _buildAITipSection(),
                        const SizedBox(height: 16),
                        const Text("Recent Job Activity", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _buildRecentActivityList(),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 210,
      decoration: BoxDecoration(color: bgWhite, border: Border(right: BorderSide(color: Colors.grey[200]!))),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _sidebarItem(Icons.dashboard, "Dashboard", isSelected: true),
          _sidebarItem(Icons.add_box, "Post Job", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddJob()))),
          _sidebarItem(Icons.work, "Manage Jobs", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsList()))),
          _sidebarItem(Icons.auto_awesome, "AI Insights", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIInsightsPage()))),
          const Spacer(),
          _sidebarItem(Icons.logout, "Logout", onTap: () => Navigator.pushReplacementNamed(context, '/login')),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, {bool isSelected = false, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isSelected ? primaryOrange : Colors.grey[600], size: 20),
      title: Text(label, style: TextStyle(color: isSelected ? primaryOrange : Colors.black87, fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      dense: true,
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _smallStatCard("Active Jobs", _activeJobsCount.toString(), Icons.campaign),
        const SizedBox(width: 10),
        _smallStatCard("Applicants", "84", Icons.groups),
        const SizedBox(width: 10),
        _smallStatCard("AI Score", "92%", Icons.auto_awesome),
      ],
    );
  }

  Widget _smallStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgWhite,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primaryOrange, size: 16),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgWhite, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Top Hiring Skills", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => EmployerApi.generateReport(),
                style: ElevatedButton.styleFrom(backgroundColor: primaryOrange, padding: const EdgeInsets.symmetric(horizontal: 10)),
                icon: const Icon(Icons.download, color: Colors.white, size: 14),
                label: const Text("PDF Report", style: TextStyle(color: Colors.white, fontSize: 11)),
              )
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 140,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 40, color: primaryOrange, title: 'Python', radius: 40, titleStyle: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                  PieChartSectionData(value: 30, color: Colors.orange[200], title: 'SQL', radius: 40, titleStyle: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                  PieChartSectionData(value: 30, color: Colors.grey[200], title: 'Other', radius: 40, titleStyle: const TextStyle(fontSize: 9)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAITipSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryOrange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryOrange.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb, color: primaryOrange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "AI Tip: Jobs with 'Remote' receive 40% more applicants.",
              style: TextStyle(color: Colors.grey[700], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList() {
    final activities = [
      {"title": "New Application", "desc": "Rahul M. applied for Python Intern", "time": "2h ago"},
      {"title": "Interview Scheduled", "desc": "Priya S. for Flutter Developer", "time": "Yesterday"},
    ];

    return Column(
      children: activities.map((act) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bgWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(act['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(act['desc']!, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                ],
              ),
              Text(act['time']!, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
            ],
          ),
        );
      }).toList(),
    );
  }
}