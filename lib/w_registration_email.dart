import 'package:flutter/material.dart';
import 'w_registration_phone.dart';
import 'w_sign_in.dart';
import 'w_OTP.dart';
// TODO: Jangan lupa import halaman-halaman tujuan di bawah ini jika file-nya sudah ada
// import 'warga_registration_phone.dart';
// import 'warga_sign_in.dart';
// import 'warga_otp.dart'; // Asumsi tombol lanjut mengarah ke OTP

class WRegistrationEmail extends StatefulWidget {
  const WRegistrationEmail({super.key});

  @override
  State<WRegistrationEmail> createState() => _WRegistrationEmailState();
}

class _WRegistrationEmailState extends State<WRegistrationEmail> {
  // Widget bantuan untuk membuat form input berulang agar kode lebih rapi
  Widget _buildTextField(String label, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            obscureText:
                isPassword, // Menyembunyikan teks jika ini adalah password
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. Tombol Back di pojok kiri atas
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(
              context,
            ); // Fungsi untuk kembali ke halaman sebelumnya
          },
        ),
      ),
      // Menggunakan SingleChildScrollView agar tidak error saat keyboard muncul
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Daftar',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 2. Tombol Pilihan (Nomor HP & Email)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Nomor HP
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman pendaftaran via Nomor HP
                      // Ganti 'WargaRegistrationPhone()' sesuai nama class yang Anda buat

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WRegistrationPhone(),
                        ),
                      );

                      print("Pindah ke tab Nomor HP");
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'Nomor HP',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Tombol Email (Aktif)
                  Container(
                    width: 120,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors
                          .grey[600], // Warna lebih gelap menandakan sedang aktif
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 3. Kolom Input (Bisa diketik)
              _buildTextField('Email'),
              const SizedBox(height: 15),
              _buildTextField('Nama depan'),
              const SizedBox(height: 15),
              _buildTextField('Nama belakang'),
              const SizedBox(height: 15),
              _buildTextField(
                'Kata sandi',
                isPassword: true,
              ), // Sengaja saya perbaiki typo "Kata sansi"-nya ya!
              // Teks kecil di bawah kata sandi
              const Padding(
                padding: EdgeInsets.only(top: 4, left: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '*minimal 8 karakter',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 4. Teks "Sudah memiliki akun? Masuk di sini" dengan link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah memiliki akun? ',
                    style: TextStyle(fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke halaman Login
                      // Ganti 'WargaSignIn()' dengan nama class login Anda

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WSignIn(),
                        ),
                      );

                      print("Pergi ke Halaman Masuk / Login");
                    },
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline, // Garis bawah
                      ),
                    ),
                  ),
                  const Text(' di sini', style: TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 50),

              // 5. Tombol Lanjut
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman selanjutnya (misalnya OTP)
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WOtp()),
                  );
                  
                  print("Lanjut ditekan");
                },
                child: Container(
                  width: double.infinity, // Memenuhi lebar layar sesuai padding
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Lanjut',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
