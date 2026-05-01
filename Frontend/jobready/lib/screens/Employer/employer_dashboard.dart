import 'package:flutter/material.dart';
import '../../services/employer_api.dart';
import 'jobs_list.dart';
import 'add_job.dart';

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
  List<dynamic> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        EmployerApi.getJobs(),
        EmployerApi.getApplications(),
      ]);

      if (mounted) {
        setState(() {
          _activeJobsCount = results[0].length;
          _applications = results[1];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showContactDialog(int id) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Message Candidate"),
        content: TextField(
          controller: controller, 
          decoration: const InputDecoration(
            hintText: "Enter interview details or feedback...",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryOrange),
            onPressed: () async {
              await EmployerApi.updateApplication(id, "SHORTLISTED", controller.text);
              Navigator.pop(ctx);
              _refreshData();
            },
            child: const Text("Send Message", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
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
        title: const Text("Employer Dashboard", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: Row(
        children: [
          if (_isSidebarOpen) _buildSidebar(),
          Expanded(
            child: Container(
              color: surfaceGrey,
              child: _isLoading 
                ? Center(child: CircularProgressIndicator(color: primaryOrange))
                : RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Recruitment Overview", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _buildStatsRow(),
                          const SizedBox(height: 25),
                          const Text("Manage Applicants", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          _buildApplicationList(),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationList() {
    if (_applications.isEmpty) return const Center(child: Text("No applicants found."));
    return Column(
      children: _applications.map((app) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(app['candidate_username'] ?? "Candidate", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Applied for: ${app['job_title']}"),
              trailing: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                child: Text("${app['match_score']}% Match", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showContactDialog(app['id']),
                  icon: Icon(Icons.message, size: 18, color: primaryOrange),
                  label: Text("Contact", style: TextStyle(color: primaryOrange)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: primaryOrange, elevation: 0),
                  child: const Text("Shortlist", style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      )).toList(),
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
          const Spacer(),
          _sidebarItem(Icons.logout, "Logout", onTap: () => Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false)),
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
        _smallStatCard("Applicants", _applications.length.toString(), Icons.groups),
      ],
    );
  }

  Widget _smallStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: bgWhite, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: primaryOrange, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}