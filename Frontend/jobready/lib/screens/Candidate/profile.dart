import 'package:flutter/material.dart';
import 'package:jobready/services/candidate_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future profile;

  @override
  void initState() {
    super.initState();
    profile = CandidateApi.getProfile(); // ✅ FIXED
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: FutureBuilder(
        future: profile,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;

          return Text(data.toString());
        },
      ),
    );
  }
}