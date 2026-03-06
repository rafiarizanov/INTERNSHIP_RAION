import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'sans-serif',
      ),
      home: const RiwayatLaporanPage(),
    );
  }
}

class RiwayatLaporanPage extends StatelessWidget {
  const RiwayatLaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background abu muda agar card terlihat
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Riwayat Laporan',
          style: TextStyle(
            color: Color(0xFF003D4C),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF003D4C)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildReportCard(
            status: 'Laporan Dibaca',
            statusColor: const Color(0xFFBDE7F1),
            statusTextColor: const Color(0xFF00838F),
            title: 'Air Mengandung Endapan',
            desc: 'Terdapat endapan pasir halus di dasar ember setelah air ditampung selama beberapa jam.',
            location: 'Jatiasih',
            date: '10/02/2026',
          ),
          _buildReportCard(
            status: 'Laporan Diproses',
            statusColor: const Color(0xFFFFF1AD),
            statusTextColor: const Color(0xFFB48A00),
            title: 'Air Berbau',
            desc: 'Air mengeluarkan bau menyengat seperti besi sejak dua hari terakhir, terutama saat pagi dan malam hari.',
            location: 'Jatisampurna',
            date: '07/02/2026',
          ),
          _buildReportCard(
            status: 'Laporan Selesai',
            statusColor: const Color(0xFFC8E6C9),
            statusTextColor: const Color(0xFF2E7D32),
            title: 'Air Berwarna Hitam',
            desc: 'Air berubah menjadi kehitaman saat pertama kali dinyalakan dan berbau tidak sedap.',
            location: 'Mustika Jaya',
            date: '02/02/2026',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Report'),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF00838F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.history, color: Colors.white),
            ),
            label: 'Riwayat',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String title,
    required String desc,
    required String location,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusTextColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF003D4C)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003D4C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF006064),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF003D4C)),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(fontSize: 12, color: Color(0xFF003D4C))),
                const SizedBox(width: 40),
                const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF003D4C)),
                const SizedBox(width: 4),
                Text(date, style: const TextStyle(fontSize: 12, color: Color(0xFF003D4C))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}