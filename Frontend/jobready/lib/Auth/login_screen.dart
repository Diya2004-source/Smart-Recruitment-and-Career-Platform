import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../screens/screen_selection.dart';
import 'registration_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  // ================= LOGIN FUNCTION =================
  Future<bool> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return false;

    setState(() => _isLoading = true);

    try {
      var result = await AuthService().loginUser(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );

      if (!mounted) return false;

      setState(() => _isLoading = false);

      if (result["success"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Welcome to HireHub")),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result["message"] ?? "Invalid credentials"),
          ),
        );
        return false;
      }
    } catch (e) {
      if (!mounted) return false;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Server unreachable. Please try again."),
        ),
      );

      return false;
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                Image.asset(
                  'assets/images/Logo.png',
                  width: 180,
                  errorBuilder: (c, e, s) => const Icon(
                    Icons.lock_open,
                    size: 80,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // ================= FORM =================
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
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Email required";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(val)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 15),

                        _buildTextField(
                          "Password",
                          Icons.lock,
                          _passController,
                          isPass: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Password required";
                            }
                            if (val.length < 6) {
                              return "Minimum 6 characters required";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 25),

                        // ================= BUTTON =================
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    bool success = await _handleLogin();

                                    if (success && mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SelectionScreen(),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "LOGIN",
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
                ),

                const SizedBox(height: 15),

                // ================= REGISTER LINK =================
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const Registration(),
                          ),
                        );
                      },
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
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}