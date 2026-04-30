import 'package:flutter/material.dart';

class ResumeUploadPage extends StatefulWidget {
  const ResumeUploadPage({super.key});

  @override
  State<ResumeUploadPage> createState() => _ResumeUploadPageState();
}

class _ResumeUploadPageState extends State<ResumeUploadPage> {
  final Color primaryOrange = const Color(0xFFFF8C00);
  bool _isUploading = false;

  void _simulateUpload() async {
    setState(() => _isUploading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    setState(() => _isUploading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Resume uploaded and parsed successfully!"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Resume Management"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0.5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 80, color: primaryOrange.withOpacity(0.5)),
            const SizedBox(height: 20),
            const Text("Upload your PDF Resume", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "Our AI will parse your skills and match you with the best Rajkot-based IT opportunities.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            _isUploading 
              ? CircularProgressIndicator(color: primaryOrange)
              : OutlinedButton(
                  onPressed: _simulateUpload,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryOrange),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Select PDF File", style: TextStyle(color: primaryOrange, fontWeight: FontWeight.bold)),
                ),
          ],
        ),
      ),
    );
  }
}