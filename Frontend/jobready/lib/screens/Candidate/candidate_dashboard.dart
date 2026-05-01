import 'package:flutter/material.dart';
import 'package:jobready/services/candidate_api.dart';
import 'job_feed.dart';

class jobseekerdashboard extends StatefulWidget {
  const jobseekerdashboard({super.key});

  @override
  State<jobseekerdashboard> createState() => _jobseekerdashboardState();
}

class _jobseekerdashboardState extends State<jobseekerdashboard> {
  int _appliedCount = 0;
  int _availableCount = 0;
  List<dynamic> _recentJobs = [];
  List<dynamic> _myApplications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final results = await Future.wait([
        CandidateApi.getApplications(),
        CandidateApi.getJobs(),
      ]);

      setState(() {
        _myApplications = results[0];
        _appliedCount = _myApplications.length;
        _availableCount = results[1].length;
        _recentJobs = results[1].take(3).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Dashboard Refresh Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Candidate Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      drawer: _buildSidebar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : RefreshIndicator(
              onRefresh: _fetchDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Welcome, Candidate", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildStatsCard(),
                    const SizedBox(height: 25),
                    const Text("My Applications & Messages", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _buildAppliedJobsSection(),
                    const SizedBox(height: 25),
                    _buildJobHeader(),
                    ..._recentJobs.map((job) => _buildJobCard(job)).toList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAppliedJobsSection() {
    if (_myApplications.isEmpty) return const Text("No applications found yet.");
    return Column(
      children: _myApplications.map((app) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ExpansionTile(
          leading: const Icon(Icons.business_center, color: Colors.orange),
          title: Text(app['job_title'], style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Status: ${app['status']}"),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Employer Message:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                    child: Text(app['employer_message'] ?? "No messages from the employer yet. Please check back later."),
                  ),
                ],
              ),
            )
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.orange, Colors.orangeAccent]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(_appliedCount.toString(), "Applied"),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStatColumn(_availableCount.toString(), "Jobs Open"),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildJobHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Latest Openings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobFeed())),
          child: const Text("View All", style: TextStyle(color: Colors.orange)),
        ),
      ],
    );
  }

  Widget _buildJobCard(dynamic job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(job['title'] ?? 'Job Title', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${job['company_name']} • ${job['location']}"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.orange),
            currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Colors.orange)),
            accountName: Text("Candidate Name"),
            accountEmail: Text("candidate@example.com"),
          ),
          ListTile(leading: const Icon(Icons.dashboard, color: Colors.orange), title: const Text("Dashboard"), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text("Logout"), onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false)),
        ],
      ),
    );
  }
}