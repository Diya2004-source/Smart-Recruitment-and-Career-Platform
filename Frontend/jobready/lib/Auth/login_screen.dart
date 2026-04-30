// import 'package:flutter/material.dart';
// import '../services/auth_services.dart';
// import '../services/session.dart';

// class login extends StatefulWidget {
//   const login({super.key});

//   @override
//   State<login> createState() => _loginState();
// }

// class _loginState extends State<login> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passController = TextEditingController();

//   bool _isLoading = false;

//   final Color brandOrange = const Color(0xFFFF8C00);

//   Future<void> _handleLogin() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final result = await AuthService().loginUser(
//         email: _emailController.text.trim(),
//         password: _passController.text.trim(),
//       );

//       debugPrint("LOGIN RESPONSE: $result");

//       final token = result["access"];

//       if (token == null) {
//         throw Exception("Token not received from backend");
//       }

//       // ✅ SAFE ROLE EXTRACTION
//       String role = "CANDIDATE";

//       if (result["user"] != null && result["user"]["role"] != null) {
//         role = result["user"]["role"].toString().toUpperCase();
//       }

//       // Save session
//       await Session.saveSession(token, role);

//       setState(() => _isLoading = false);

//       // ROLE BASED NAVIGATION
//       if (role == "ADMIN") {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/admindashboard',
//           (route) => false,
//         );
//       } 
//       else if (role == "RECRUITER") {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/employerdashboard',
//           (route) => false,
//         );
//       } 
//       else {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/jobseekerdashboard',
//           (route) => false,
//         );
//       }

//     } catch (e) {
//       setState(() => _isLoading = false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Login failed: $e")),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: brandOrange,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),

//                 Image.asset(
//                   'assets/images/Logo.png',
//                   width: 120,
//                 ),

//                 const SizedBox(height: 20),

//                 const Text(
//                   "Welcome Back",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 25),

//                 Form(
//                   key: _formKey,
//                   child: Container(
//                     padding: const EdgeInsets.all(22),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: const InputDecoration(
//                             labelText: "Email",
//                           ),
//                           validator: (v) =>
//                               v == null || v.isEmpty ? "Enter email" : null,
//                         ),

//                         const SizedBox(height: 10),

//                         TextFormField(
//                           controller: _passController,
//                           obscureText: true,
//                           decoration: const InputDecoration(
//                             labelText: "Password",
//                           ),
//                           validator: (v) =>
//                               v == null || v.isEmpty ? "Enter password" : null,
//                         ),

//                         const SizedBox(height: 20),

//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: brandOrange,
//                             ),
//                             onPressed: _isLoading ? null : _handleLogin,
//                             child: _isLoading
//                                 ? const SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 2,
//                                     ),
//                                   )
//                                 : const Text("Login"),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, '/registration');
//                   },
//                   child: const Text(
//                     "Don't have an account? Register",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


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

        // ✅ REDIRECTION WITH ARGUMENTS
        if (role == "ADMIN") {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            '/admindashboard', 
            (r) => false, 
            arguments: token, // 🔥 Passing token to prevent the dashboard from kicking you out
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brandOrange,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
                  const SizedBox(height: 10),
                  TextFormField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: brandOrange),
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                        : const Text("Login", style: TextStyle(color: Colors.white)),
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