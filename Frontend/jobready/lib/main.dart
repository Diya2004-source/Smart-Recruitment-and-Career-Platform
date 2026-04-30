// import 'package:flutter/material.dart';

// import 'Auth/login_screen.dart';
// import 'Auth/registration_screen.dart';

// import './screens/screen_selection.dart';
// import './screens/Candidate/candidate_dashboard.dart';
// import './screens/Employer/employer_dashboard.dart';
// import './screens/Admin/admin_dashboard.dart';
// import './screens/Admin/users_list.dart';

// import './services/session.dart';
// import './splash_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Session.loadSession();

//   runApp(const HireHub());
// }

// class HireHub extends StatelessWidget {
//   const HireHub({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'HireHub',

//       home: const SplashScreen(),

//       routes: {
//         '/login': (context) => const login(),
//         '/registration': (context) => const registration(),
//         '/selectionscreen': (context) => const selectionscreen(),
//         '/jobseekerdashboard': (context) => const jobseekerdashboard(),
//         '/employerdashboard': (context) => const employerdashboard(),
//         '/admindashboard': (context) => const admindashboard(),
//       },

//       onGenerateRoute: (settings) {
//         switch (settings.name) {
//           case '/users':
//             final args = settings.arguments as Map;
//             return MaterialPageRoute(
//               builder: (_) => UsersListPage(
//                 token: args['token'],
//                 type: args['type'],
//               ),
//             );
//         }
//         return null;
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'Auth/login_screen.dart';
import 'Auth/registration_screen.dart';
import 'screens/Admin/admin_dashboard.dart';
import 'screens/Candidate/candidate_dashboard.dart';
import 'screens/Employer/employer_dashboard.dart';
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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const login(),
        '/registration': (context) => const registration(),
        '/admindashboard': (context) => const admindashboard(),
        '/employerdashboard': (context) => const employerdashboard(),
        '/jobseekerdashboard': (context) => const jobseekerdashboard(),
      },
    );
  }
}