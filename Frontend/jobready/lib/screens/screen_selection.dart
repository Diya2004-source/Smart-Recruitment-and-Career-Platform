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
      //  HEADER WITH BACK ARROW
      appBar: AppBar(
        backgroundColor: brandOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/login'); //  redirect to login
          },
        ),
        title: const Text("Select Role"),
        centerTitle: true,
      ),

      //  BODY
      body: Container(
        decoration: BoxDecoration(
          // Gradient using your brand color
          gradient: LinearGradient(
            colors: [
              brandOrange,
              brandOrange.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome ",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Image.asset(  
                  'assets/images/Logo.png',
                  width: 200,
                ),
                const Text(
                  "Choose your role to continue",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 40),

                // Job Seeker Card
                _buildCard(
                  icon: Icons.person,
                  title: "I am a Job Seeker",
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/jobseekerdashboard');
                  },
                ),

                const SizedBox(height: 20),

                // Employer Card
                _buildCard(
                  icon: Icons.business,
                  title: "I am an Employer",
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/employerdashboard');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Card
  Widget _buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.orange),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}