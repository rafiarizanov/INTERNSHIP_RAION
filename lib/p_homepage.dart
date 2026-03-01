import 'package:INTERNSHIP_RAION/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'p_sign_in.dart';

class P_Homepage extends StatelessWidget {
  const P_Homepage({super.key});

  // Fungsi untuk Logout
  void _logout(BuildContext context) {

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PSignIn()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
   
    final authProv = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF004D56),
              radius: 20,
              child: Icon(Icons.location_on, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wilayah Tugas:',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Text(
                  authProv.namaDaerah.isEmpty ? 'Umum' : authProv.namaDaerah,
                  style: const TextStyle(
                    color: Color(0xFF004D56),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        // --- TOMBOL LOGOUT SEPERTI W_HOMEPAGE ---
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () => _logout(context),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFF004D56),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Ringkasan Laporan Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF004D56).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFF004D56).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ringkasan Laporan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D56),
                    ),
                  ),
                  const Text(
                    "Maret 2026",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBox("Total Laporan"),
                      _buildStatBox("Dalam Proses"),
                      _buildStatBox("Selesai"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Grafik Laporan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF004D56),
              ),
            ),
            const Text(
              "Periode 6 bulan terakhir",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 15),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(child: Text("Grafik Laporan")),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavbar(0),
    );
  }

  Widget _buildStatBox(String title) {
    return Container(
      width: 90,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF004D56),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }
}

// Global Navbar Helper untuk Petugas
Widget _buildNavbar(int index) {
  return BottomNavigationBar(
    currentIndex: index,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    selectedItemColor: const Color(0xFF004D56),
    unselectedItemColor: Colors.grey,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Dashboard'),
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment_turned_in_outlined),
        label: 'Kegiatan',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ],
  );
}
