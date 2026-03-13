import 'package:INTERNSHIP_RAION/providers/auth_gate.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          mainAxisSize: MainAxisSize.min, 
          children: [
            Image.asset(
              'assets/image/logo.png',
              width: 60, 
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12), 
            Image.asset(
              'assets/image/nama.png',
              width: 200, 
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
