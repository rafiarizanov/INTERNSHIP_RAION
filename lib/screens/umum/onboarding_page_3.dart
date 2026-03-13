import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'choosing.dart';

class OnboardingPage3 extends StatefulWidget {
  const OnboardingPage3({super.key});

  @override
  State<OnboardingPage3> createState() => _OnboardingPage3State();
}

class _OnboardingPage3State extends State<OnboardingPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'assets/image/onboarding_3.png',
                  height: 300,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(height: 300, width: double.infinity, color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
                  },
                ),
                const SizedBox(height: 40),
                Text(
                  'Laporkan Air Kotor dengan Cepat',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3Bold.copyWith(color: AppColors.primaryPetugas),
                ),
                const SizedBox(height: 15),
                Text(
                  'Temukan air keruh atau berbau? Laporkan langsung melalui aplikasi dan pantau status penanganannya.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title1.copyWith(color: Colors.black54, height: 1.5),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                    const SizedBox(width: 8),
                    const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                    const SizedBox(width: 8),
                    Container(
                      width: 30, height: 8,
                      decoration: BoxDecoration(color: AppColors.primaryPetugas, borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChoosingPage()));
                  },
                  child: Container(
                    width: double.infinity, height: 55,
                    decoration: BoxDecoration(color: AppColors.primaryPetugas, borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text('Mulai Sekarang', style: AppTextStyles.title2Bold.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}