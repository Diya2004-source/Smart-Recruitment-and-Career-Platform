import 'package:flutter/material.dart';
import '../../services/candidate_api.dart';

class JobDetailPage extends StatefulWidget {
  final int jobId;
  const JobDetailPage({super.key, required this.jobId});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final Color primaryOrange = const Color(0xFFFF8C00);
  Map<String, dynamic>? _job;
  bool _isLoading = true;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();
    _fetchJobDetails();
  }

  Future<void> _fetchJobDetails() async {
    try {
      // Reusing getJobs and filtering by ID for consistency with your API structure
      final jobs = await CandidateApi.getJobs();
      setState(() {
        _job = jobs.firstWhere((j) => j['id'] == widget.jobId);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Error loading job details: $e");
    }
  }

  Future<void> _handleApply() async {
    setState(() => _isApplying = true);
    try {
      await CandidateApi.applyJob(widget.jobId);
      _showSnackBar("Application submitted successfully!", isError: false);
      Navigator.pop(context); // Return to feed after applying
    } catch (e) {
      setState(() => _isApplying = false);
      _showSnackBar("Already applied or error occurred.");
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Job Details", style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      bottomNavigationBar: _buildApplyButton(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: primaryOrange))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const Divider(height: 40),
                  const Text("Job Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    _job?['description'] ?? "No description provided.",
                    style: TextStyle(color: Colors.grey[800], fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text("Requirements", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildRequirementsList(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _job?['title'] ?? "Position",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _job?['company_name'] ?? "Company",
          style: TextStyle(fontSize: 18, color: primaryOrange, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _infoChip(Icons.location_on_outlined, _job?['location'] ?? "Remote"),
            const SizedBox(width: 10),
            _infoChip(Icons.work_outline, _job?['job_type'] ?? "Full-time"),
          ],
        ),
      ],
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildRequirementsList() {
    // Assuming requirements come as a comma-separated string or list from Django
    final reqs = _job?['requirements']?.toString().split(',') ?? ["Experience with relevant tech stack"];
    return Column(
      children: reqs.map((req) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_outline, size: 18, color: primaryOrange),
            const SizedBox(width: 10),
            Expanded(child: Text(req.trim(), style: const TextStyle(fontSize: 14))),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildApplyButton() {
    if (_isLoading) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: ElevatedButton(
        onPressed: _isApplying ? null : _handleApply,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isApplying
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Apply Now", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}