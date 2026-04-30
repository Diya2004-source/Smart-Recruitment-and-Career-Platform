import 'package:flutter/material.dart';
import '../../services/candidate_api.dart';
import 'job_feed.dart';

class jobseekerdashboard extends StatefulWidget {
  const jobseekerdashboard({super.key});

  @override
  State<jobseekerdashboard> createState() => _jobseekerdashboardState();
}

class _jobseekerdashboardState extends State<jobseekerdashboard> {
  final Color primaryOrange = const Color(0xFFFF8C00);
  bool _isSidebarOpen = true;
  String _candidateName = "Candidate";
  int _appliedCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        CandidateApi.getApplications(),
        CandidateApi.getProfile(),
      ]);

      setState(() {
        _appliedCount = (results[0] as List).length;
        // Accessing name from the profile map
        _candidateName = (results[1] as Map)['full_name'] ?? "Candidate";
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryOrange, // Orange BG
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // White Icons
        leading: IconButton(
          icon: Icon(_isSidebarOpen ? Icons.menu_open : Icons.menu),
          onPressed: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
        ),
        title: const Text(
          "Candidate Panel", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold) // White Font
        ),
      ),
      body: Row(
        children: [
          if (_isSidebarOpen) _buildSidebar(),
          Expanded(
            child: _isLoading 
              ? Center(child: CircularProgressIndicator(color: primaryOrange))
              : _buildDashboardContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _sidebarItem(Icons.dashboard, "Dashboard", isSelected: true),
          _sidebarItem(Icons.search, "Find Jobs", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const JobFeed()));
          }),
          _sidebarItem(Icons.assignment, "My Applications"),
          _sidebarItem(Icons.person, "Profile"),
          const Spacer(),
          _sidebarItem(Icons.logout, "Logout"),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title, {bool isSelected = false, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isSelected ? primaryOrange : Colors.grey),
      title: Text(title, style: TextStyle(color: isSelected ? primaryOrange : Colors.black87)),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome, $_candidateName", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Applications Sent", style: TextStyle(color: Colors.black54)),
                    Text("$_appliedCount", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryOrange)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}