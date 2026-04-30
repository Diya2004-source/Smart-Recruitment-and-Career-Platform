import 'package:flutter/material.dart';
import 'Auth/login_screen.dart';
import 'Auth/registration_screen.dart';
import 'screens/screen_selection.dart';
import 'splash_screen.dart';
import 'screens/Candidate/candidate_dashboard.dart';
import 'screens/Employer/employer_dashboard.dart'; // Ensure class name is EmployerDashboard
import 'screens/Admin/admin_dashboard.dart';
import 'screens/Admin/users_list.dart';
import 'screens/Admin/verify_employers.dart';
import 'screens/Admin/job_postings.dart';
import 'screens/Admin/reports_page.dart';
import 'screens/Admin/settings_page.dart'; 
import 'services/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Session.loadSession(); 
  runApp(const HireHub());
}

class HireHub extends StatelessWidget {
  const HireHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HireHub',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const SplashScreen(), 
      routes: {
        '/login': (context) => const login(),
        '/registration': (context) => const registration(),
        '/selectionscreen': (context) => const selectionscreen(),
        '/jobseekerdashboard': (context) => const jobseekerdashboard(),
        
        // FIXED: Correct class name casing
        '/employerdashboard': (context) => const employerdashboard(),
        '/admindashboard': (context) => const admindashboard(),
        
        '/verify_employers': (context) => VerifyEmployersPage(token: Session.token),
        '/job_postings': (context) => JobPostingsPage(token: Session.token),
        '/reports_page': (context) => ReportsPage(token: Session.token),
        '/settings': (context) => const SettingsPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/users_list') {
          final args = settings.arguments;
          String token = Session.token;
          String type = "all";

          if (args is String) {
            token = args;
          } else if (args is Map) {
            token = args['token'] ?? Session.token;
            type = args['type'] ?? "all";
          }

          return MaterialPageRoute(
            builder: (_) => UsersListPage(token: token, type: type),
          );
        }
        return null;
      },
    );
  }
}