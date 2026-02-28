import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: W_RiwayatLaporan(),
  ));
}

class W_RiwayatLaporan extends StatefulWidget {
  const W_RiwayatLaporan({super.key});

  @override
  State<W_RiwayatLaporan> createState() => _W_RiwayatLaporanState();
}

class _W_RiwayatLaporanState extends State<W_RiwayatLaporan> {
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
            // Tombol Back Kotak
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
              'Riwayat Laporan',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        // Padding bottom 0 agar mepet ke navbar
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
        children: [
          _buildRiwayatCard("Dibaca"),
          _buildRiwayatCard("Diproses"),
          _buildRiwayatCard("Selesai"),
          _buildRiwayatCard("Selesai"),
          const SizedBox(height: 10), // Jarak tipis terakhir
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFD9D9D9),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 3, // Tetap di highlight profil karena ini sub-menu profil
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

  // Widget Helper untuk membuat Card Riwayat
  Widget _buildRiwayatCard(String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            status,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          // Baris placeholder konten (Abu-abu lebih gelap)
          Container(height: 18, width: 200, color: const Color(0xFFAFAFAF)),
          const SizedBox(height: 8),
          Container(height: 12, width: 130, color: const Color(0xFFBDBDBD)),
          const SizedBox(height: 15),
          // Tombol/Status kotak di kanan bawah
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 30,
              width: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF9E9E9E),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }
}