import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../services/session.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => loginState();
}

class loginState extends State<login> {
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

      if (!mounted) return;

      final token = result["access"];
      final user = result["user"];

      if (token == null || user == null) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials")),
        );
        return;
      }

      final role = user["role"].toString().trim().toUpperCase();

      await Session.saveSession(token, role);

      setState(() => _isLoading = false);

      // ✅ FIXED ROLE BASED NAVIGATION
      if (role == "ADMIN") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/admindashboard',
          (route) => false,
        );
      } 
      else if (role == "RECRUITER") {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/employerdashboard',
          (route) => false,
        );
      } 
      else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/selectionscreen',
          (route) => false,
        );
      }

    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandOrange,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                Image.asset(
                  'assets/images/Logo.png',
                  width: 120,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration:
                              const InputDecoration(labelText: "Email"),
                          validator: (v) =>
                              v!.isEmpty ? "Enter email" : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passController,
                          obscureText: true,
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          validator: (v) =>
                              v!.isEmpty ? "Enter password" : null,
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandOrange,
                            ),
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("Login"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/registration');
                  },
                  child: const Text(
                    "If you don't have account, Register",
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}