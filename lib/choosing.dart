import 'package:flutter/material.dart';
import 'w_registration_email.dart';

class ChoosingPage extends StatefulWidget {
  const ChoosingPage({super.key});

  @override
  State<ChoosingPage> createState() => _ChoosingPageState();
}

class _ChoosingPageState extends State<ChoosingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Label "Masuk Sebagai (Teks)"
              Container(
                width: 180,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Masuk Sebagai (Teks)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 2. Tombol "Warga (Button)"
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WRegistrationEmail(),),);
                  // TODO: Masukkan kode navigasi ke halaman Login Warga di sini
                  print("Ke Halaman Warga");
                },
                child: Container(
                  width: 260,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    // Dibuat agak kotak seperti di gambar
                    borderRadius: BorderRadius.circular(5), 
                  ),
                  child: const Center(
                    child: Text(
                      'Warga (Button)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. Label "atau (Teks)"
              Container(
                width: 90,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'atau (Teks)',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Tombol "Petugas (Button)"
              GestureDetector(
                onTap: () {
                  // TODO: Masukkan kode navigasi ke halaman Login Petugas di sini
                  print("Ke Halaman Petugas");
                },
                child: Container(
                  width: 260,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      'Petugas (Button)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
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