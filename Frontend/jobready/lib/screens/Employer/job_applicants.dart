import 'package:flutter/material.dart';
import '../../services/employer_api.dart';

class JobApplicants extends StatefulWidget {
  final int jobId;

  const JobApplicants({super.key, required this.jobId});

  @override
  State<JobApplicants> createState() => _JobApplicantsState();
}

class _JobApplicantsState extends State<JobApplicants> {
  final api = EmployerApi();

  List applicants = [];
  bool loading = true;

  final Color brandOrange = const Color(0xFFFF8C00);

  @override
  void initState() {
    super.initState();
    load();
  }

  // ================= LOAD =================
  Future<void> load() async {
    setState(() => loading = true);

    try {
      final data = await api.getApplications(widget.jobId);

      if (!mounted) return;

      setState(() {
        applicants = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("APPLICANTS ERROR: $e");

      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load applicants")),
      );
    }
  }

  // ================= SCORE CHIP =================
  Widget scoreChip(dynamic score) {
    final value = double.tryParse(score.toString()) ?? 0;

    Color color;
    if (value >= 80) {
      color = Colors.green;
    } else if (value >= 50) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$value%",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ================= APPLICANT CARD =================
  Widget applicantCard(dynamic app) {
    final user = app['candidate'] ?? {};

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [

          // 🔥 AVATAR
          CircleAvatar(
            radius: 24,
            backgroundColor: brandOrange.withOpacity(0.2),
            child: Text(
              (user['username'] ?? "U")[0].toUpperCase(),
              style: TextStyle(
                color: brandOrange,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 🔥 INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  user['username'] ?? "Unknown",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  user['email'] ?? "No email",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Text("Match: "),
                    scoreChip(app['match_score']),
                  ],
                ),
              ],
            ),
          ),

          // 🔥 ACTION BUTTON
          IconButton(
            icon: const Icon(Icons.message),
            color: brandOrange,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Chat coming soon")),
              );
            },
          )
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Applicants",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: brandOrange),
      ),

      body: RefreshIndicator(
        onRefresh: load,

        child: loading
            ? const Center(child: CircularProgressIndicator())

            : applicants.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "No Applicants Yet",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  )

                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: applicants
                        .map((app) => applicantCard(app))
                        .toList(),
                  ),
      ),
    );
  }
}