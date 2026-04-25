import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'Auth/registration_screen.dart';
import 'Auth/login_screen.dart';
import './screens/screen_selection.dart';

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
      // Entry point
      home: const SplashScreen(),

      // Define Named Routes
      routes: {
        '/Registration': (context) => const Registration(),
        '/Login': (context) => const Login(),
        '/SelectionScreen': (context) => const SelectionScreen(),
      },
    );
  }
}
