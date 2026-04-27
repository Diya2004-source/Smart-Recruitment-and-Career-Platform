import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  String _selectedRole = "CANDIDATE"; //  NOW CHANGEABLE
  bool _isLoading = false;

  final Color brandOrange = const Color(0xFFFF8C00);

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  // ================= REGISTER FUNCTION =================
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    var result = await AuthService().registerUser(
      username: _userController.text.trim(),
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
      role: _selectedRole, //  PASS ROLE
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result["success"]) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Thank you for registration"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"])),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandOrange,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Image.asset('assets/images/Logo.png', width: 200),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildField("Username", Icons.person, _userController),
                        const SizedBox(height: 15),

                        _buildField("Email", Icons.email, _emailController,
                            validator: (val) {
                          if (val == null || val.isEmpty) return "Email required";
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
                            return "Invalid email";
                          }
                          return null;
                        }),

                        const SizedBox(height: 15),

                        _buildField("Password", Icons.lock, _passController,
                            isPass: true, validator: (val) {
                          if (val == null || val.length < 6) {
                            return "Min 6 characters required";
                          }
                          return null;
                        }),

                        const SizedBox(height: 15),

                        _buildField(
                          "Confirm Password",
                          Icons.lock_outline,
                          _confirmPassController,
                          isPass: true,
                          validator: (val) {
                            if (val != _passController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        //  ROLE DROPDOWN
                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.work, color: brandOrange),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "CANDIDATE",
                              child: Text("Candidate"),
                            ),
                            DropdownMenuItem(
                              value: "RECRUITER",
                              child: Text("Recruiter"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandOrange,
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("REGISTER"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text(
                      "Already have an account? login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= FIELD BUILDER =================
  Widget _buildField(
    String hint,
    IconData icon,
    TextEditingController ctr, {
    bool isPass = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctr,
      obscureText: isPass,
      validator: validator ??
          (val) => val == null || val.isEmpty ? "$hint required" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: brandOrange),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}