import 'package:flutter/material.dart';
import '../../services/admin_services.dart';

class UsersListPage extends StatefulWidget {
  final String token;
  final String type; // Added to support filtering

  const UsersListPage({
    super.key, 
    required this.token, 
    this.type = "all", // Default to showing all users
  });

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final AdminApiService _apiService = AdminApiService();
  late Future<List<UserModel>> _usersFuture;
  final Color primaryOrange = const Color(0xFFFF8C00);

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Extracted logic to make refreshing easier
  void _loadUsers() {
    setState(() {
      _usersFuture = _apiService.getUsers(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F9),
      appBar: AppBar(
        title: Text(
          widget.type == "all" ? "User Directory" : "${widget.type}s List",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: primaryOrange),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadUsers(),
        color: primaryOrange,
        child: FutureBuilder<List<UserModel>>(
          future: _usersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No users found."));
            }

            // Filter users based on the 'type' passed from the dashboard
            final users = widget.type == "all" 
                ? snapshot.data! 
                : snapshot.data!.where((u) => u.role.toUpperCase() == widget.type.toUpperCase()).toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: primaryOrange.withOpacity(0.1),
                      child: Text(user.username[0].toUpperCase(), 
                          style: TextStyle(color: primaryOrange, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(user.role, style: TextStyle(color: Colors.grey.shade600)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _confirmDelete(user),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: Text("Are you sure you want to remove ${user.username}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              bool success = await _apiService.deleteUser(widget.token, user.id);
              if (success) _loadUsers();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}