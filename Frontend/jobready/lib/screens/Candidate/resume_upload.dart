import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/candidate_api.dart';

class ResumeUpload extends StatefulWidget {
  const ResumeUpload({super.key});

  @override
  State<ResumeUpload> createState() => _ResumeUploadState();
}

class _ResumeUploadState extends State<ResumeUpload> {
  final api = CandidateApi();
  File? file;
  bool loading = false;

  Future pickFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
      setState(() {});
    }
  }

  Future upload() async {
    if (file == null) return;

    setState(() => loading = true);

    await api.uploadResume(file!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Uploaded")),
    );

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Resume")),
      body: Column(
        children: [
          ElevatedButton(onPressed: pickFile, child: const Text("Pick File")),
          ElevatedButton(onPressed: upload, child: const Text("Upload")),
        ],
      ),
    );
  }
}