import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../services/session.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;
  final Color brandOrange = const Color(0xFFFF8C00);

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await AuthService().loginUser(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );

      if (result["success"] == true) {
        final token = result["access"];
        if (token == null) throw Exception("Token missing from server");

        String role = "CANDIDATE";
        if (result["user"] != null && result["user"]["role"] != null) {
          role = result["user"]["role"].toString().toUpperCase();
        }

        await Session.saveSession(token, role);

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (role == "ADMIN") {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/admindashboard', 
            (r) => false, 
            arguments: token,
          );
        } else if (role == "RECRUITER") {
          Navigator.pushNamedAndRemoveUntil(context, '/employerdashboard', (r) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/jobseekerdashboard', (r) => false);
        }
      } else {
        throw Exception(result["message"] ?? "Invalid credentials");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  // Matching the helper from the registration page for consistency
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
                  
                  // Logo added to match registration
                  Image.asset('assets/images/Logo.png', width: 200),
                  
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.black87
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildField(
                          "Email", 
                          Icons.email, 
                          _emailController,
                          validator: (val) {
                            if (val == null || val.isEmpty) return "Email required";
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) return "Invalid email";
                            return null;
                          }
                        ),
                        
                        const SizedBox(height: 15),
                        
                        _buildField(
                          "Password", 
                          Icons.lock, 
                          _passController, 
                          isPass: true
                        ),
                        
                        const SizedBox(height: 25),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                              ),
                            ),
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading 
                              ? const SizedBox(
                                  height: 20, 
                                  width: 20, 
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                ) 
                              : const Text("LOGIN", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Registration Link outside the white form
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/registration'),
                    child: const Text(
                      "Don't have an account? Register here",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
}