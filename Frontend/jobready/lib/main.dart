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

      // ROUTES
      routes: {
        '/login': (context) => const login(),
        '/registration': (context) => const registration(),
        '/selectionscreen': (context) => const selectionscreen(),
        '/jobseekerdashboard': (context) => const jobseekerdashboard(),
        '/employerdashboard': (context) => const employerdashboard(),
      },

      //  IMPORTANT: routes that need arguments must use onGenerateRoute
      onGenerateRoute: (settings) {
        switch (settings.name) {

          // ================= ADMIN DASHBOARD =================
          case '/admindashboard':
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => admindashboard(),
              settings: RouteSettings(arguments: token),
            );

          // ================= USERS LIST =================
          case '/users':
            final args = settings.arguments as Map;
            return MaterialPageRoute(
              builder: (_) => UsersListPage(
                token: args['token'],
                type: args['type'],
              ),
            );
        }

        return null;
      },
    );
  }
}