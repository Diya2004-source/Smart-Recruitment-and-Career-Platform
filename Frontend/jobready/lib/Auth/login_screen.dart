import 'package:flutter/material.dart';
import '../services/auth_services.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // ================= LOGIN =================
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await AuthService().loginUser(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (result["access"] == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Login failed")),
  );
  return;
}

      final token = result["access"];
      final role = result["user"]?["role"];

      if (role == "admin") {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/admindashboard',
          (_) => false,
          arguments: token,
        );
      } else {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/selectionscreen', (_) => false);
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: $e")));
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
            child: Column(
              children: [
                const SizedBox(height: 40),

                Image.asset(
                  'assets/images/Logo.png',
                  width: 140,
                  errorBuilder: (_, __, _) =>
                      const Icon(Icons.lock, size: 80, color: Colors.white),
                ),

                const SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _buildTextField(
                          "Email",
                          Icons.email,
                          _emailController,
                          validator: (val) => val == null || val.isEmpty
                              ? "Email required"
                              : null,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          "Password",
                          Icons.lock,
                          _passController,
                          isPass: true,
                          validator: (val) => val == null || val.isEmpty
                              ? "Password required"
                              : null,
                        ),
                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandOrange,
                              foregroundColor: Colors.white,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/registration'),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= TEXT FIELD =================
  Widget _buildTextField(
    String hint,
    IconData icon,
    TextEditingController ctr, {
    bool isPass = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctr,
      obscureText: isPass,
      validator: validator,
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
