import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './reports_page.dart';
import 'users_list.dart';

class admindashboard extends StatefulWidget {
  const admindashboard({super.key});

  @override
  State<admindashboard> createState() => _admindashboardState();
}

class _admindashboardState extends State<admindashboard> {
  final Color primary = const Color(0xFFFF8C00);

  bool loading = true;
  Map<String, dynamic>? data;
  String token = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    token = args.toString();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => loading = true);

    final res = await http.get(
      Uri.parse("http://10.0.2.2:8000/api/accounts/admin/dashboard/"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      setState(() {
        data = jsonDecode(res.body);
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  // ================= NAVIGATION =================

  void openUsers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UsersListPage(
          token: token,
          type: "all",
        ),
      ),
    );
  }

  void openReports() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportsPage(token: token),
      ),
    );
  }

  void logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  // ================= CARD CLICK =================

  void onCardTap(String type) {
    if (type == "users") openUsers();
    if (type == "reports") openReports();
  }

  // ================= DASHBOARD UI =================

  Widget dashboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Dashboard",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // ================= CARDS =================
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            children: [

              _card("Users", data?["total_users"] ?? 0,
                  Icons.people, Colors.blue,
                  () => onCardTap("users")),

              _card("Candidates", data?["candidates"] ?? 0,
                  Icons.person, Colors.green,
                  () => onCardTap("candidates")),

              _card("Employers", data?["employers"] ?? 0,
                  Icons.work, primary,
                  () => onCardTap("employers")),

              _card("Reports", data?["reports"] ?? 0,
                  Icons.report, Colors.purple,
                  () => onCardTap("reports")),
            ],
          ),

          const SizedBox(height: 25),

          // ================= AFTER CARDS SECTION (NEW ADDITION) =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _box(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "System Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _miniStat("Active Jobs", "${data?["active_jobs"] ?? 0}"),
                    _miniStat("Total Users", "${data?["total_users"] ?? 0}"),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("System Status:"),
                    Text(
                      "Healthy",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= QUICK INSIGHTS =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _box(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Quick Insights",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8),

                Text("• Users activity increasing"),
                Text("• Reports being resolved regularly"),
                Text("• Job postings are active"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= CARD =================

  Widget _card(String title, dynamic value, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _box(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  // ================= MINI STATS =================

  Widget _miniStat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title),
      ],
    );
  }

  // ================= STYLE =================

  BoxDecoration _box() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 10),
      ],
    );
  }

  // ================= DRAWER =================

  Widget sidebar() {
    return Drawer(
      child: Column(
        children: [

          DrawerHeader(
            decoration: BoxDecoration(color: primary),
            child: const Center(
              child: Text(
                "ADMIN PANEL",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => Navigator.pop(context),
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Users"),
            onTap: openUsers,
          ),

          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Reports"),
            onTap: openReports,
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: logout,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primary),
        title: const Text(
          "Admin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      drawer: sidebar(),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : dashboardView(),
    );
  }
}