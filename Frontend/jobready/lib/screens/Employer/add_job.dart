import 'package:flutter/material.dart';
import '../../services/employer_api.dart';
import 'theme/colors.dart';

class AddJob extends StatefulWidget {
  final String token;

  const AddJob({super.key, required this.token});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final api = EmployerApi();

  final title = TextEditingController();
  final skills = TextEditingController();
  final location = TextEditingController();
  final desc = TextEditingController();

  void submit() async {
    await api.createJob(widget.token, {
      "title": title.text,
      "required_skills": skills.text.split(","),
      "location": location.text,
      "description": desc.text,
    });

    Navigator.pop(context);
  }

  Widget field(String hint, controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,

      appBar: AppBar(title: const Text("Create Job")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            field("Job Title", title),
            field("Skills (comma separated)", skills),
            field("Location", location),
            field("Description", desc),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: submit,
              child: const Text("Publish Job"),
            ),
          ],
        ),
      ),
    );
  }
}