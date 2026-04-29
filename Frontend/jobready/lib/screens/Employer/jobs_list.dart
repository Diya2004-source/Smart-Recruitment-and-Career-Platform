import 'package:flutter/material.dart';
import '../../services/employer_api.dart';
import 'job_applicants.dart';

class JobsList extends StatefulWidget {
  final int? selectedJobId;

  const JobsList({super.key, this.selectedJobId});

  @override
  State<JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  final api = EmployerApi();

  List jobs = [];
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
      final data = await api.getJobs();

      if (!mounted) return;

      setState(() {
        jobs = data;
        loading = false;
      });
    } catch (e) {
      debugPrint("JOBS ERROR: $e");

      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load jobs")),
      );
    }
  }

  // ================= JOB CARD =================
  Widget jobCard(dynamic job) {
    final isSelected = widget.selectedJobId == job['id'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobApplicants(jobId: job['id']),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: brandOrange, width: 2)
              : null,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [

            // 🔥 ICON
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: brandOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.work, color: brandOrange),
            ),

            const SizedBox(width: 12),

            // 🔥 JOB INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    job['title'] ?? "No Title",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        job['location'] ?? "Unknown",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // 🔥 STATUS
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (job['is_active'] ?? true)
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (job['is_active'] ?? true)
                          ? "Active"
                          : "Closed",
                      style: TextStyle(
                        color: (job['is_active'] ?? true)
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 ARROW
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
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
          "Your Jobs",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: brandOrange),
      ),

      body: RefreshIndicator(
        onRefresh: load,

        child: loading
            ? const Center(child: CircularProgressIndicator())

            : jobs.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Icon(
                        Icons.work_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          "No Jobs Posted Yet",
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
                    children: jobs.map((job) => jobCard(job)).toList(),
                  ),
      ),
    );
  }
}