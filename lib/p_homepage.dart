import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: P_Homepage(), debugShowCheckedModeBanner: false));

class P_Homepage extends StatelessWidget {
  const P_Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: Row(children: [
          const CircleAvatar(backgroundColor: Colors.grey, radius: 20),
          const SizedBox(width: 12),
          const Text('Hello, User!', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 20),
          // Ringkasan Laporan Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(15)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Ringkasan Laporan", style: TextStyle(fontWeight: FontWeight.bold)),
              const Text("Maret 2026", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildStatBox("Total Laporan"), _buildStatBox("Dalam Proses"), _buildStatBox("Selesai"),
              ]),
            ]),
          ),
          const SizedBox(height: 25),
          const Text("Grafik Laporan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text("Periode 6 bulan terakhir", style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 15),
          Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFD9D9D9), borderRadius: BorderRadius.circular(15))),
          const SizedBox(height: 10),
        ]),
      ),
      bottomNavigationBar: _buildNavbar(0),
    );
  }

  Widget _buildStatBox(String title) {
    return Container(
      width: 90, height: 100,
      decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 10))),
    );
  }
}

// Global Navbar Helper untuk Petugas
Widget _buildNavbar(int index) {
  return BottomNavigationBar(
    currentIndex: index, type: BottomNavigationBarType.fixed,
    backgroundColor: const Color(0xFFD9D9D9), selectedItemColor: Colors.black,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in_outlined), label: 'Kegiatan'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ],
  );
}