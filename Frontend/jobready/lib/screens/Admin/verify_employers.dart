import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VerifyEmployersPage extends StatefulWidget {
  final String token;
  const VerifyEmployersPage({super.key, required this.token});

  @override
  State<VerifyEmployersPage> createState() => _VerifyEmployersPageState();
}

class _VerifyEmployersPageState extends State<VerifyEmployersPage> {
  List employers = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchPendingEmployers();
  }

  Future<void> fetchPendingEmployers() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    // Replace with your actual Django endpoint for pending recruiters
    final url = Uri.parse('http://10.0.2.2:8000/api/accounts/admin/pending-recruiters/');
    
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // If your Django response is a Map with a key like 'results', use data['results']
          employers = data is List ? data : (data['employers'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Server Error: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Connection Failed. Is the server running?";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Employers", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : employers.isEmpty
                  ? const Center(child: Text("No pending verification requests"))
                  : RefreshIndicator(
                      onRefresh: fetchPendingEmployers,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: employers.length,
                        itemBuilder: (context, index) {
                          final emp = employers[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.orangeAccent,
                                child: Icon(Icons.business, color: Colors.white),
                              ),
                              title: Text(emp['company_name'] ?? "No Name", 
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(emp['email'] ?? "No Email"),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                onPressed: () => _verifyAction(emp['id']),
                                child: const Text("Verify", style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  void _verifyAction(int id) {
    // Logic to call your backend verify endpoint
    print("Verifying employer ID: $id");
  }
}