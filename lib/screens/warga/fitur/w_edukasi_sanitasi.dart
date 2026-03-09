import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: W_Edukasi(),
  ));
}

class W_Edukasi extends StatefulWidget {
  const W_Edukasi({super.key});

  @override
  State<W_Edukasi> createState() => _W_EdukasiState();
}

class _W_EdukasiState extends State<W_Edukasi> {
  final Color primaryTeal = const Color(0xFF003D4C);
  final Color lightBg = const Color(0xFFE0F7FA);
  final Color activeTagColor = const Color(0xFF00838F);

  // Data konten disesuaikan dengan gambar sanitasi
  final List<Map<String, String>> artikelData = [
    {
      'judul': 'Langkah Kecil yang Penting 🧼',
      'sub': 'Mencuci tangan dengan sabun dapat mencegah hingga 50% penyakit yang ditularkan melalui air.',
      'tag': 'Edukasi Sanitasi',
    },
  ];

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
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: primaryTeal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Text(
              'Edukasi',
              style: TextStyle(
                color: primaryTeal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Filter Section ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filter Kategori",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: primaryTeal,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildFilterChip("Semua", false),
                    const SizedBox(width: 8),
                    _buildFilterChip("Air Bersih", false),
                    const SizedBox(width: 8),
                    _buildFilterChip("Sanitasi", true), // Di-set TRUE agar terpilih (Sanitasi)
                  ],
                ),
              ],
            ),
          ),
          
          // --- List Section ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: artikelData.length,
              itemBuilder: (context, index) {
                return _buildCardEdukasi(artikelData[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardEdukasi(Map<String, String> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightBg.withOpacity(0.6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder Gambar
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.wash_outlined, color: Colors.grey[500], size: 40),
          ),
          const SizedBox(height: 12),
          // Tag Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: activeTagColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              data['tag']!,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          // Judul
          Text(
            data['judul']!,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primaryTeal,
            ),
          ),
          const SizedBox(height: 6),
          // Subtitle
          Text(
            data['sub']!,
            style: TextStyle(
              fontSize: 13,
              color: primaryTeal.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 15),
          // Tombol
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Baca Selengkapnya  ',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? primaryTeal : lightBg,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : primaryTeal,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}