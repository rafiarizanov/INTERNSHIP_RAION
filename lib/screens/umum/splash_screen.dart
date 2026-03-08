import 'package:INTERNSHIP_RAION/providers/auth_gate.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_page_1.dart';

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
          MaterialPageRoute(
            builder: (context) => const AuthGate(),
          ),
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
          children: [
            SizedBox(
              width: 80, 
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
              
                  Positioned(
                    bottom: 15, 
                    child: Image.asset(
                      'assets/image/logo_1.png',
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  Positioned(
                    bottom: 28, 
                    child: Image.asset(
                      'assets/image/logo_2.png',
                      width: 35,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12), 
            Padding(
              padding: const EdgeInsets.only(bottom: 5), 
              child: Image.asset(
                'assets/image/nama.png',
                height: 35, 
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}