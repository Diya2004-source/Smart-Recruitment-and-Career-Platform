import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/session.dart';

class admindashboard extends StatefulWidget {
  const admindashboard({super.key});

  @override
  State<admindashboard> createState() => _admindashboardState();
}

class _admindashboardState extends State<admindashboard> {
  final Color primaryOrange = const Color(0xFFFF8C00);
  final Color backgroundGray = const Color(0xFFF4F7F9);

  bool loading = true;
  Map<String, dynamic>? data;
  String token = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    
    // Safety check: prioritize passed arguments, fallback to Session service
    if (args != null) {
      token = args.toString();
    } else {
      token = Session.token;
    }

    if (token.isEmpty) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return;
    }
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final res = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/accounts/admin/dashboard/"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (res.statusCode == 200 && mounted) {
        setState(() {
          data = jsonDecode(res.body);
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  void _navigateTo(String routeName) {
    Navigator.pushNamed(context, routeName, arguments: token);
  }

  // ================= SIDEBAR (YOUR ORIGINAL UI) =================
  Widget _buildSidebar() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(color: primaryOrange),
            child: Column(
              children: [
                const Icon(Icons.business, size: 50, color: Colors.white),
                const SizedBox(height: 12),
                const Text("HireHub Admin",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _navItem(Icons.analytics, "Insight Overview", () => Navigator.pop(context)),
          _navItem(Icons.people_alt, "User Directory", () => _navigateTo('/users_list')),
          _navItem(Icons.assignment_turned_in, "Verify Employers", () => _navigateTo('/verify_employers')),
          _navItem(Icons.campaign, "Job Postings", () => _navigateTo('/job_postings')),
          _navItem(Icons.description, "System Reports", () => _navigateTo('/reports_page')),
          const Divider(),
          _navItem(Icons.settings, "Platform Settings", () => _navigateTo('/settings')),
          const Spacer(),
          _navItem(Icons.logout, "Sign Out", () {
            Session.logout();
            Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
          }, isLogout: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : primaryOrange.withOpacity(0.8)),
      title: Text(title, style: TextStyle(color: isLogout ? Colors.red : Colors.black87, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  // ================= DASHBOARD UI COMPONENTS =================
  Widget _aiInsightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryOrange.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: primaryOrange, size: 20),
              const SizedBox(width: 8),
              const Text("AI TALENT ADVISOR", style: TextStyle(letterSpacing: 1.2, fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Software engineering applications are up 20% this week. We recommend promoting more 'Junior Developer' roles to meet the candidate surge.",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _recentActivity() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recent Platform Activity", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _activityTile("New Employer", "TechCorp Solutions registered.", "2 mins ago"),
          _activityTile("Report Filed", "Job #405 flagged for spam.", "45 mins ago"),
          _activityTile("System Update", "Database backup completed.", "3 hours ago"),
        ],
      ),
    );
  }

  Widget _activityTile(String title, String sub, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(height: 8, width: 8, decoration: BoxDecoration(color: primaryOrange, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12))])),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryOrange),
        title: const Text("Control Center", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      drawer: _buildSidebar(),
      body: loading
          ? Center(child: CircularProgressIndicator(color: primaryOrange))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _aiInsightCard(),
                  const SizedBox(height: 24),
                  const Text("Key Statistics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _statCard("Total Candidates", data?["candidates"] ?? 0, Icons.people, Colors.blue, '/users_list'),
                      _statCard("Verified Recruiters", data?["recruiters"] ?? 0, Icons.verified_user, Colors.indigo, '/verify_employers'),
                      _statCard("Live Job Posts", data?["total_jobs"] ?? 0, Icons.work_outline, Colors.teal, '/job_postings'),
                      _statCard("Pending Reports", data?["reports"] ?? 0, Icons.warning_amber_rounded, Colors.red, '/reports_page'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _recentActivity(),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String label, dynamic value, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () => _navigateTo(route),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}