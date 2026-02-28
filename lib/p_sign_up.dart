import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: P_Daftar(),
  ));
}

class P_Daftar extends StatelessWidget {
  const P_Daftar({super.key});

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
              "Daftar",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            // Nama Lengkap
            _buildLabel("Nama Lengkap"),
            _buildInputBox(),
            
            // Tanggal Lahir
            _buildLabel("Tanggal Lahir"),
            _buildInputBox(),
            
            // NIK Dari Instansi
            _buildLabel("NIK Dari Instansi"),
            _buildInputBox(),
            
            // Jabatan
            _buildLabel("Jabatan"),
            _buildInputBox(),
            
            const SizedBox(height: 50),
            
            // Tombol Selanjutnya
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  "Selanjutnya",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Link ke Login
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun? ", style: TextStyle(fontSize: 13)),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.only(bottom: 8, top: 15),
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