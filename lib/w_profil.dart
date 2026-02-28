import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: W_Profil(),
  ));
}

class W_Profil extends StatefulWidget {
  const W_Profil({super.key});

  @override
  State<W_Profil> createState() => _W_ProfilState();
}

class _W_ProfilState extends State<W_Profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
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
        // Padding bottom 0 supaya konten bener-bener turun ke navbar
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
        child: Column(
          children: [
            // Section Header Profil (Avatar + Nama + Tombol Edit)
            Row(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xFF9E9E9E),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 25, width: 120, decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(5))),
                      const SizedBox(height: 10),
                      Container(height: 15, width: 80, decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(5))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Edit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 8, width: double.infinity, color: const Color(0xFFD9D9D9)), // Divider tebal
            
            const SizedBox(height: 25),

            // Card Laporan Terbaru Anda
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Laporan Terbaru Anda", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                  const SizedBox(height: 15),
                  Container(height: 25, width: double.infinity, color: const Color(0xFFAFAFAF)),
                  const SizedBox(height: 10),
                  Container(height: 15, width: 150, color: const Color(0xFFBDBDBD)),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(color: const Color(0xFF9E9E9E), borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 15),

            // List Menu (Riwayat Laporan, dll)
            _buildMenuItem("Riwayat Laporan"),
            _buildMenuItem("Pusat Bantuan"),
            _buildMenuItem("Tentang Aplikasi"),

            // Spasi minimal agar mepet ke navbar
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFD9D9D9),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 3, // Highlight icon Profile
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

  // Helper untuk membuat item list menu di profil
  Widget _buildMenuItem(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFF9E9E9E), borderRadius: BorderRadius.circular(10))),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54))),
          const Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }
}