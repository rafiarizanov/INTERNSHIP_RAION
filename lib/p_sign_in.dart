import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: P_Login(),
  ));
}

class P_Login extends StatelessWidget {
  const P_Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Masuk",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            // Input Email/No Telp
            _buildLabel("Email atau Nomor telepon"),
            _buildInputBox(),
            
            const SizedBox(height: 20),
            
            // Input Kata Sandi
            _buildLabel("Kata sandi"),
            _buildInputBox(),
            
            const SizedBox(height: 10),
            
            // Baris Ingat Saya & Lupa Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("Ingat saya", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const Text("Lupa kata sandi?", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            
            const SizedBox(height: 50),
            
            // Tombol Masuk
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  "Masuk",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Link ke Daftar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun? ", style: TextStyle(fontSize: 13)),
                const Text(
                  "Daftar",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildInputBox() {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}