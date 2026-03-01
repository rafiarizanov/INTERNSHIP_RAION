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
    // Timer 5 detik sebelum pindah ke halaman Onboarding
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OnboardingPage1(),
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
            // --- BAGIAN LOGO ---
            // Menggunakan SizedBox agar Stack memiliki ruang yang pasti
            SizedBox(
              width: 80, 
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Kuncup Hijau (Berada di paling bawah/dasar)
                  Positioned(
                    bottom: 15, // Mengatur posisi naik turun kuncup
                    child: Image.asset(
                      'assets/image/logo_1.png',
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // 2. Tetesan Air (Ditempelkan di atas kuncup)
                  Positioned(
                    bottom: 28, // Menyesuaikan agar tetesan duduk pas di tengah kuncup
                    child: Image.asset(
                      'assets/image/logo_2.png',
                      width: 35,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12), // Jarak antara logo dan tulisan

            // --- BAGIAN NAMA APPS ---
            // Menggunakan Padding untuk fine-tuning posisi teks agar sejajar mata
            Padding(
              padding: const EdgeInsets.only(bottom: 5), 
              child: Image.asset(
                'assets/image/nama.png',
                height: 35, // Ukuran disesuaikan dengan proporsi logo
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}