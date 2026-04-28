import 'package:flutter/material.dart';
import '../../services/employer_api.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final api = EmployerApi();

  final _formKey = GlobalKey<FormState>();

  final title = TextEditingController();
  final skills = TextEditingController();
  final location = TextEditingController();
  final desc = TextEditingController();

  bool loading = false;

  final orange = const Color(0xFFFF8C00);

  // ================= SUBMIT =================
  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await api.createJob({
        "title": title.text.trim(),
        "description": desc.text.trim(),
        "required_skills":
            skills.text.split(",").map((e) => e.trim()).toList(),
        "location": location.text.trim(),
        "is_active": true
      });

      if (!mounted) return;

      // ✅ RETURN TRUE → dashboard will refresh
      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => loading = false);
  }

  // ================= INPUT =================
  Widget input(String label, TextEditingController c) {
    return TextFormField(
      controller: c,
      validator: (v) => v == null || v.isEmpty ? "$label required" : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: orange),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Post Job"),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.orange),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              // ===== HEADER CARD =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Create Job",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("Fill details to post a job",
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== FORM =====
              input("Job Title", title),
              const SizedBox(height: 12),

              input("Location", location),
              const SizedBox(height: 12),

              input("Skills (comma separated)", skills),
              const SizedBox(height: 12),

              TextFormField(
                controller: desc,
                maxLines: 4,
                validator: (v) =>
                    v == null || v.isEmpty ? "Description required" : null,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===== BUTTON =====
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Post Job",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}