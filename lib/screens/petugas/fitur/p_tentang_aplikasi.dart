import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TentangAplikasiPage(),
  ));
}

class TentangAplikasiPage extends StatelessWidget {
  const TentangAplikasiPage({super.key});

  // Warna tema sesuai gambar
  final Color primaryTeal = const Color(0xFF003D4C);

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
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primaryTeal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'Tentang Aplikasi',
              style: TextStyle(
                color: primaryTeal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(flex: 1),
            
            // Logo Aplikasi
            Image.asset(
              'assets/image/logo.png',
              height: 150, // Sesuaikan ukuran
              fit: BoxFit.contain,
            ),
            
            const SizedBox(height: 10),
            
            // Nama Logo (Sadar Air)
            Image.asset(
              'assets/image/nama.png',
              height: 60, // Sesuaikan ukuran
              fit: BoxFit.contain,
            ),
            
            const SizedBox(height: 30),
            
            // Deskripsi Teks
            Text(
              "Sadar Air adalah platform digital terintegrasi yang memudahkan masyarakat melaporkan kondisi air kotor secara real-time melalui foto dan lokasi, sekaligus menyediakan edukasi sanitasi untuk meningkatkan kesadaran, mempercepat respons petugas, dan mendukung pengelolaan kualitas air berkelanjutan di Kota Bekasi",
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: primaryTeal,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            
            const Spacer(flex: 2),
            
            // Footer Credit
            Text(
              "Made with ♥ by Kelompok 6\nfor Raion Community Internship 2026",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tombol Kembali
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Kembali",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
}