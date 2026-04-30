import 'package:flutter/material.dart';
import '../../services/candidate_api.dart';
import 'job_detail.dart';

class JobFeed extends StatefulWidget {
  const JobFeed({super.key});

  @override
  State<JobFeed> createState() => _JobFeedState();
}

class _JobFeedState extends State<JobFeed> {
  final Color primaryOrange = const Color(0xFFFF8C00);
  
  List<dynamic> _allJobs = [];      // Now properly used in _filterJobs
  List<dynamic> _filteredJobs = [];
  bool _isLoading = true;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final jobs = await CandidateApi.getJobs();
      if (mounted) {
        setState(() {
          _allJobs = jobs;
          _filteredJobs = jobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _filterJobs(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredJobs = _allJobs;
      } else {
        _filteredJobs = _allJobs.where((job) {
          final title = (job['title'] ?? "").toString().toLowerCase();
          final company = (job['company_name'] ?? "").toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) || company.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // UPDATED: Orange AppBar with White Text to match Sidebar style
      appBar: AppBar(
        backgroundColor: primaryOrange,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Find Jobs", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchJobs,
          )
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryChips(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: primaryOrange))
                : _filteredJobs.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _fetchJobs,
                        color: primaryOrange,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredJobs.length,
                          itemBuilder: (context, index) => _buildJobCard(_filteredJobs[index]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        onChanged: _filterJobs,
        decoration: InputDecoration(
          hintText: "Search title or company...",
          prefixIcon: Icon(Icons.search, color: primaryOrange),
          filled: true,
          fillColor: const Color(0xFFF1F3F4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ["All", "Flutter", "Python", "Django", "React"];
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = (_searchQuery == categories[index] || (index == 0 && _searchQuery.isEmpty));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (val) => _filterJobs(categories[index] == "All" ? "" : categories[index]),
              selectedColor: primaryOrange.withOpacity(0.2),
              checkmarkColor: primaryOrange,
              labelStyle: TextStyle(
                color: isSelected ? primaryOrange : Colors.grey[700],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: const Color(0xFFF1F3F4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.business_center, color: primaryOrange),
        ),
        title: Text(
          job['title'] ?? 'Untitled Position',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(job['company_name'] ?? 'Company', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(job['location'] ?? 'Remote', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(width: 12),
                Icon(Icons.work_outline, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(job['job_type'] ?? 'Full-time', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: primaryOrange),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobDetailPage(jobId: job['id'])),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No jobs found.", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchJobs,
            style: ElevatedButton.styleFrom(backgroundColor: primaryOrange),
            child: const Text("Retry", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}