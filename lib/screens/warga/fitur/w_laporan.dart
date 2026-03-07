import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: W_Laporan(),
  ));
}

class W_Laporan extends StatefulWidget {
  const W_Laporan({super.key});

  @override
  State<W_Laporan> createState() => _W_LaporanState();
}

class _W_LaporanState extends State<W_Laporan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Laporkan Masalah',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.stop, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Padding bottom 0 agar konten bisa mepet maksimal ke bawah
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Tanggal"),
            _buildInputBox(height: 45),
            
            _buildLabel("Lokasi"),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.location_on, color: Colors.grey, size: 40),
            ),
            
            _buildLabel("Kategori"),
            _buildInputBox(
              height: 45, 
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(""),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              )
            ),
            
            _buildLabel("Deskripsi"),
            _buildInputBox(height: 80),
            
            _buildLabel("Upload Gambar"),
            _buildInputBox(
              height: 60,
              child: const Icon(Icons.file_upload_outlined, color: Colors.grey),
            ),
            
            const SizedBox(height: 30),
            
            // Tombol Kirim
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Kirim",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
            
            // Jarak mepet ke Navbar
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFD9D9D9),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 1, // Highlight icon lapor (lonceng)
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notification_important, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: ''),
        ],
      ),
    );
  }

  // Widget bantuan untuk Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Widget bantuan untuk Input Box (Warna abu-abu khas UI kamu)
  Widget _buildInputBox({double height = 45, Widget? child}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9).withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}