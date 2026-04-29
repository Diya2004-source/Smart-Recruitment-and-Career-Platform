import 'package:flutter/material.dart';
import '../../services/candidate_api.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final api = CandidateApi();
  Map? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    profile = await api.getProfile();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text("Username: ${profile!['user']['username']}"),
                Text("Experience: ${profile!['experience_years']} yrs"),
              ],
            ),
    );
  }
}