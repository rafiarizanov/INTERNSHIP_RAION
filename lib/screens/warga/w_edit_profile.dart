import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: W_EditProfil(),
  ));
}

class W_EditProfil extends StatefulWidget {
  const W_EditProfil({super.key});

  @override
  State<W_EditProfil> createState() => _W_EditProfilState();
}

class _W_EditProfilState extends State<W_EditProfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Tombol Back Kotak sesuai gambar
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            const Text(
              'Edit Profil',
              style: TextStyle(
                color: Colors.black, 
                fontSize: 18, 
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Foto Profil Bulat Besar
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF9E9E9E),
              ),
            ),
            const SizedBox(height: 15),
            // Tombol Edit Foto
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Edit foto",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            
            const SizedBox(height: 30),

            // Form Input
            _buildInputLabel("Nama"),
            _buildInputField(),

            _buildInputLabel("Email"),
            _buildInputField(),

            _buildInputLabel("Nomor Telepon"),
            _buildInputField(),

            _buildInputLabel("Tanggal lahir"),
            _buildInputField(),

            const SizedBox(height: 50),

            // Tombol Simpan
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  "Simpan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                    color: Colors.black87
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Label Input
  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 15),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.bold,
            color: Colors.black87
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Kotak Input (Warna abu-abu sesuai UI kamu)
  Widget _buildInputField() {
    return Container(
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9).withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}