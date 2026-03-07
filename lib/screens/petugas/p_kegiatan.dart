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
      theme: ThemeData(useMaterial3: true),
      home: const LaporanWargaPage(),
    );
  }
}

class LaporanWargaPage extends StatelessWidget {
  const LaporanWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- AppBar ---
      appBar: AppBar(
        title: const Text(
          'Kelola Laporan Warga',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Filter Chips (Tabs) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua', isSelected: true),
                  _buildFilterChip('Dibaca'),
                  _buildFilterChip('Diproses'),
                  _buildFilterChip('Selesai'),
                ],
              ),
            ),
          ),

          // --- Skeleton Text / Subtitle ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 12,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // --- List of Cards ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildLaporanCard();
              },
            ),
          ),
        ],
      ),
      // --- Bottom Navigation Bar ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_suggest_outlined), label: 'Kegiatan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // Widget untuk Chip Filter
  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[600] : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget untuk Card Laporan
  Widget _buildLaporanCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _skeleton(width: 60, height: 15),
              _skeleton(width: 70, height: 15, isRounded: true),
            ],
          ),
          const SizedBox(height: 12),
          _skeleton(width: 130, height: 25),
          const SizedBox(height: 8),
          _skeleton(width: double.infinity, height: 10),
          const SizedBox(height: 4),
          _skeleton(width: 250, height: 10),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18),
              const SizedBox(width: 4),
              _skeleton(width: 140, height: 12),
              const SizedBox(width: 12),
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 4),
              _skeleton(width: 110, height: 12),
            ],
          ),
        ],
      ),
    );
  }

  // Helper untuk membuat kotak abu-abu (placeholder)
  Widget _skeleton({double? width, double? height, bool isRounded = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(isRounded ? 15 : 4),
      ),
    );
  }
}