import 'package:flutter/material.dart';


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
      home: const NotificationPage(),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF004D40), // Warna hijau gelap tombol back
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              onPressed: () {},
            ),
          ),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF004D40),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNotificationItem(
                icon: Icons.hourglass_empty,
                title: 'Laporan Anda Sedang Diproses',
                subtitle: 'Laporan Anda dengan ID LP007 sedang ditinjau oleh petugas. Kami akan memberi tahu jika ada perkembangan terbaru.',
                isFirst: true,
              ),
              _buildNotificationItem(
                icon: Icons.chat_bubble_outline,
                title: 'Petugas Menanggapi Laporan Anda',
                subtitle: 'Laporan Anda dengan ID LP006 telah ditanggapi petugas. Lihat selengkapnya pada halaman detail laporan.',
              ),
              _buildNotificationItem(
                icon: Icons.check_circle_outline,
                title: 'Laporan Anda Selesai Ditangani',
                subtitle: 'Laporan Anda dengan ID LP005 telah selesai ditangani. Terima kasih sudah peduli dengan kualitas air di sekitarmu!',
                isLast: true,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF00838F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.home),
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: 'Report'),
          const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        // Membuat garis putus-putus antar item menggunakan border bawah (pendekatan sederhana)
        border: isLast ? null : const Border(bottom: BorderSide(color: Colors.blue, width: 1, style: BorderStyle.solid)),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF00838F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF004D40),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}