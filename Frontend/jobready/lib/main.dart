import 'package:flutter/material.dart';

import 'splash_screen.dart';
import 'Auth/registration_screen.dart';
import 'Auth/login_screen.dart';

import './screens/screen_selection.dart';
import './screens/Candidate/candidate_dashboard.dart';
import './screens/Employer/employer_dashboard.dart';
import './screens/Admin/admin_dashboard.dart';
import './screens/Admin/users_list.dart';

void main() {
  runApp(const HireHub());
}

class HireHub extends StatelessWidget {
  const HireHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HireHub',

      // ENTRY SCREEN
      home: const SplashScreen(),

      // ================= STATIC ROUTES =================
      routes: {
        '/login': (context) => const login(),
        '/registration': (context) => const registration(),
        '/selectionscreen': (context) => const selectionscreen(),
        '/jobseekerdashboard': (context) => const jobseekerdashboard(),
      },

      // ================= DYNAMIC ROUTES =================
      onGenerateRoute: (settings) {
        switch (settings.name) {

          // ================= EMPLOYER DASHBOARD =================
          case '/employerdashboard':
            final token = settings.arguments;

            if (token is String && token.isNotEmpty) {
              return MaterialPageRoute(
                builder: (_) => employerdashboard(token: token),
              );
            }

            return _errorRoute("Employer token missing");

          // ================= ADMIN DASHBOARD =================
          case '/admindashboard':
            final token = settings.arguments;

            if (token is String && token.isNotEmpty) {
              return MaterialPageRoute(
                builder: (_) => admindashboard(),
                settings: RouteSettings(arguments: token),
              );
            }

            return _errorRoute("Admin token missing");

          // ================= USERS LIST =================
          case '/users':
            final args = settings.arguments;

            if (args is Map &&
                args.containsKey('token') &&
                args.containsKey('type')) {
              return MaterialPageRoute(
                builder: (_) => UsersListPage(
                  token: args['token'],
                  type: args['type'],
                ),
              );
            }

            return _errorRoute("Users arguments missing");
        }

        return null;
      },
    );
  }

  // ================= ERROR SCREEN =================
  MaterialPageRoute _errorRoute(String msg) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Text(
            msg,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}