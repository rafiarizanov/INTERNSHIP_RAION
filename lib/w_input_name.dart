import 'package:flutter/material.dart';

class WInputName extends StatefulWidget {
  const WInputName({super.key});

  @override
  State<WInputName> createState() => _WInputNameState();
}

class _WInputNameState extends State<WInputName> {
  // Controller untuk mengambil data input jika diperlukan nanti
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Widget _buildInputBox(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20), // Bentuk lonjong sesuai gambar
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 60), // Jarak atas agar komposisi pas
              
              // Input Nama Depan
              _buildInputBox('Nama depan', _firstNameController),
              
              const SizedBox(height: 25),
              
              // Input Nama Belakang
              _buildInputBox('Nama belakang', _lastNameController),

              const SizedBox(height: 150), // Ruang kosong sesuai desain gambar

              // Tombol Lanjut
              GestureDetector(
                onTap: () {
                  // Tambahkan navigasi ke Dashboard atau halaman Utama di sini
                  print("Nama: ${_firstNameController.text} ${_lastNameController.text}");
                },
                child: Container(
                  width: 250, // Ukuran tombol sedikit lebih kecil sesuai gambar
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Lanjut',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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