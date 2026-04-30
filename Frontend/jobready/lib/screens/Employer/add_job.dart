import 'package:flutter/material.dart';
import '../../services/employer_api.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final location = TextEditingController();
  final skills = TextEditingController();
  final desc = TextEditingController();

  bool loading = false;

  final Color orange = const Color(0xFFFF8C00);

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final skillList = skills.text
          .split(",")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await EmployerApi.createJob({
        "title": title.text.trim(),
        "description": desc.text.trim(),
        "required_skills": skillList,
        "location": location.text.trim(),
        "is_active": true,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job posted successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create job: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Widget input(String label, TextEditingController c, {int maxLines = 1}) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      validator: (v) =>
          v == null || v.trim().isEmpty ? "$label required" : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  void dispose() {
    title.dispose();
    location.dispose();
    skills.dispose();
    desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Post Job"),
        backgroundColor: orange,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              input("Job Title", title),
              const SizedBox(height: 10),
              input("Location", location),
              const SizedBox(height: 10),
              input("Skills (comma separated)", skills),
              const SizedBox(height: 10),
              input("Description", desc, maxLines: 4),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: loading ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Post Job"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}