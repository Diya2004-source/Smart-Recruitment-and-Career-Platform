import 'package:flutter/material.dart';

class selectionscreen extends StatefulWidget {
  const selectionscreen({super.key});

  @override
  State<selectionscreen> createState() => _selectionscreenState();
}

class _selectionscreenState extends State<selectionscreen> {
  final Color brandOrange = const Color(0xFFFF8C00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: brandOrange,
        title: const Text("Select Role"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [brandOrange, brandOrange.withOpacity(0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Logo.png', width: 180),

              const SizedBox(height: 20),

              const Text(
                "Choose your role",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 40),

              _buildCard(
                icon: Icons.person,
                title: "Job Seeker",
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/jobseekerdashboard',
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 20),

              _buildCard(
                icon: Icons.business,
                title: "Employer",
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/employerdashboard',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}