import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import './Auth/registration_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 2. Define Animations: Scale for pop and Opacity for smoothness
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    // 3. Start the animations immediately
    _controller.forward();

    // 4. Navigation Timer: Wait 4 seconds then transition
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const registration()), 
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Crucial for preventing memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandOrange = Color(0xFFFF8C00);

    // This makes the system status bar (time/battery) match your app theme
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: brandOrange,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Animation: Scaling and Fading
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 180,
                    // errorBuilder: (context, error, stackTrace) {
                    //   // Fallback if image fails to load
                    //   return const Icon(Icons.business_center, color: Colors.white, size: 80);
                    // },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Slogan Animation: Fades in after the logo
              FadeTransition(
                opacity: _opacityAnimation,
                child: const Text(
                  'Dream. Match. Work.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}