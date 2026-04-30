import 'package:flutter/material.dart';
import 'package:jobready/services/candidate_api.dart';

class ResumeUpload extends StatefulWidget {
  const ResumeUpload({super.key});

  @override
  State<ResumeUpload> createState() => _ResumeUploadState();
}

class _ResumeUploadState extends State<ResumeUpload> {
  late Future profile;

  @override
  void initState() {
    super.initState();
    profile = CandidateApi.getProfile(); // ✅ FIXED
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Resume")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // upload logic here
          },
          child: const Text("Upload"),
        ),
      ),
    );
  }
}