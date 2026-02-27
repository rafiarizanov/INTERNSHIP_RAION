import 'package:flutter/material.dart';
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
    Future.delayed(const Duration(seconds: 5), () {
      // Pindah ke halaman baru dan hapus splash screen dari riwayat back
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // Sesuaikan nama class ini dengan nama class di file onboarding teman Anda
          builder: (context) => const OnboardingPage1(), 
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 208,
              height: 153,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image, size: 75, color: Colors.black54),
                  const SizedBox(height: 10),
                  const Text(
                    'Logo Apps',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
                child: const Text(
                  'Nama Apps (Text)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),     
    );
  }
}