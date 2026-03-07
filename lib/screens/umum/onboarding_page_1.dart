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

                // --- 1. GAMBAR UTAMA ---
                // Mengganti Container abu-abu dengan Image.asset
                Image.asset(
                  'assets/image/onboarding_1.png',
                  height: 300, // Ukuran sesuai mockup lo
                  fit: BoxFit.contain,
                  // Proteksi kalau gambar belum ke-load/error
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 210,
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 50),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // --- 2. JUDUL ---
                const Text(
                  'Air Bersih Itu Penting',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D56), // Warna teal gelap
                  ),
                ),

                const SizedBox(height: 15),

                // --- 3. DESKRIPSI ---
                const Text(
                  'Air yang terlihat jernih belum tentu aman. Kontaminasi bakteri dapat membahayakan kesehatan keluarga.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // --- 4. DOT INDICATOR ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF004D56),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                    const SizedBox(width: 5),
                    const CircleAvatar(radius: 4, backgroundColor: Colors.grey),
                  ],
                ),

                const SizedBox(height: 60),

                // --- 5. TOMBOL NEXT ---
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPage2(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
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