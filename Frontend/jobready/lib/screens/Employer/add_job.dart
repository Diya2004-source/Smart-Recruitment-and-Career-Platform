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
  final location = TextEditingController();
  final skills = TextEditingController();
  final desc = TextEditingController();

  bool loading = false;

  final Color brandOrange = const Color(0xFFFF8C00);

  // ================= SUBMIT =================
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      // ✅ Clean & validate skills
      final skillList = skills.text
          .split(",")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (skillList.isEmpty) {
        throw "Please enter at least one skill";
      }

      final res = await api.createJob({
        "title": title.text.trim(),
        "description": desc.text.trim(),
        "required_skills": skillList,
        "location": location.text.trim(),
        "is_active": true
      });

      debugPrint("JOB CREATED: $res");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Job posted successfully")),
      );

      Navigator.pop(context, true);

    } catch (e) {
      debugPrint("CREATE JOB ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  // ================= INPUT FIELD =================
  Widget input(
    String label,
    IconData icon,
    TextEditingController controller, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator ??
          (v) =>
              v == null || v.trim().isEmpty ? "$label is required" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: brandOrange),
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
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
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Post Job",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: brandOrange),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // 🔥 HEADER CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      brandOrange,
                      brandOrange.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create Job Post",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Fill all details carefully to attract candidates",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔥 FORM CARD
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [

                    // TITLE
                    input(
                      "Job Title",
                      Icons.work,
                      title,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Job title is required";
                        }
                        if (v.length < 3) {
                          return "Title too short";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // LOCATION
                    input(
                      "Location",
                      Icons.location_on,
                      location,
                    ),

                    const SizedBox(height: 14),

                    // SKILLS
                    input(
                      "Skills (comma separated)",
                      Icons.code,
                      skills,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Enter at least one skill";
                        }
                        if (!v.contains(",")) {
                          return "Use comma to separate skills";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // DESCRIPTION
                    input(
                      "Job Description",
                      Icons.description,
                      desc,
                      maxLines: 4,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "Description is required";
                        }
                        if (v.length < 10) {
                          return "Description too short";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Post Job",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}