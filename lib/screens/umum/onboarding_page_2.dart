import 'package:flutter/material.dart';
import 'onboarding_page_3.dart';

class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({super.key});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
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
                  'assets/image/onboarding_2.png', 
                  height: 300, 
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    );
                  },
                ),

                const SizedBox(height: 40),

            
                const Text(
                  'Belajar Jaga Air Lebih Mudah',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D56),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Dapatkan edukasi sederhana tentang sanitasi dan cara menjaga air tetap bersih untuk keluarga Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

              
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                    const SizedBox(width: 8),
                    Container(
                      width: 30, 
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF004D56),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                  ],
                ),

                const SizedBox(height: 60),

                
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPage3(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55, 
                    decoration: BoxDecoration(
                      color: const Color(0xFF004D56),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        'Lanjut',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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