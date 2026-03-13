import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'onboarding_page_2.dart';

class OnboardingPage1 extends StatefulWidget {
  const OnboardingPage1({super.key});

  @override
  State<OnboardingPage1> createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<OnboardingPage1> {
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
                  'assets/image/onboarding_1.png',
                  height: 300,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(width: 210, height: 150, color: Colors.grey[300], child: const Icon(Icons.broken_image, size: 50));
                  },
                ),
                const SizedBox(height: 40),
                Text(
                  'Air Bersih Itu Penting',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h3Bold.copyWith(color: AppColors.primaryPetugas),
                ),
                const SizedBox(height: 15),
                Text(
                  'Air yang terlihat jernih belum tentu aman. Kontaminasi bakteri dapat membahayakan kesehatan keluarga.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title1.copyWith(color: Colors.black54, height: 1.5),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30, height: 8,
                      decoration: BoxDecoration(color: AppColors.primaryPetugas, borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(width: 5),
                    const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                    const SizedBox(width: 5),
                    const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                  ],
                ),
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingPage2()));
                  },
                  child: Container(
                    width: double.infinity, height: 50,
                    decoration: BoxDecoration(color: AppColors.primaryPetugas, borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text('Lanjut', style: AppTextStyles.title2Bold.copyWith(color: Colors.white)),
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