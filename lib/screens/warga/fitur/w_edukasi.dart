import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_detail_edukasi1.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_detail_edukasi2.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_detail_edukasi3.dart';

class WEdukasi extends StatefulWidget {
  const WEdukasi({super.key});

  @override
  State<WEdukasi> createState() => _WEdukasiState();
}

class _WEdukasiState extends State<WEdukasi> {
  String _kategoriPilihan = "Semua";

  final List<Map<String, dynamic>> semuaArtikel = [
    {
      'id': 1,
      'kategori': 'Air Bersih',
      'tag': 'Edukasi Air Bersih',
      'judul': '3 Tanda Air Sumur Anda Bermasalah',
      'sub':
          'Penting untuk mengenali tanda-tanda ini agar dapat segera mengambil tindakan.',
      'gambar': 'assets/image/materi1.jpg',
    },
    {
      'id': 2,
      'kategori': 'Air Bersih',
      'tag': 'Edukasi Air Bersih',
      'judul': 'Air Jernih Belum Tentu Aman 🔍',
      'sub':
          'Air yang terlihat bening bisa saja mengandung bakteri yang berbahaya.',
      'gambar': 'assets/image/materi2.jpg',
    },
    {
      'id': 3,
      'kategori': 'Sanitasi',
      'tag': 'Edukasi Sanitasi',
      'judul': 'Langkah Kecil yang Penting 🧼',
      'sub':
          'Mencuci tangan dengan sabun dapat mencegah hingga 50% penyakit yang ditularkan melalui air.',
      'gambar': 'assets/image/materi3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final artikelDitampilkan = _kategoriPilihan == "Semua"
        ? semuaArtikel
        : semuaArtikel
              .where((artikel) => artikel['kategori'] == _kategoriPilihan)
              .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: AppColors.blueDarker,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'Edukasi',
              style: AppTextStyles.h1Bold.copyWith(color: AppColors.blueDarker),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filter Kategori",
                  style: AppTextStyles.title1Bold.copyWith(
                    color: AppColors.blueDarker,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildFilterChip("Semua"),
                    const SizedBox(width: 8),
                    _buildFilterChip("Air Bersih"),
                    const SizedBox(width: 8),
                    _buildFilterChip("Sanitasi"),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: artikelDitampilkan.length,
              itemBuilder: (context, index) =>
                  _buildCardEdukasi(artikelDitampilkan[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardEdukasi(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blueLightActive.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(data['gambar']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.blueDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data['tag']!,
              style: AppTextStyles.captionBold.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['judul']!,
            style: AppTextStyles.title2Bold.copyWith(
              color: AppColors.blueDarker,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data['sub']!,
            style: AppTextStyles.body.copyWith(
              color: AppColors.blueDarker.withOpacity(0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                if (data['id'] == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WEdukasiDetail1(),
                    ),
                  );
                } else if (data['id'] == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WEdukasiDetail2(),
                    ),
                  );
                } else if (data['id'] == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WEdukasiDetail3(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueDarker,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Baca Selengkapnya ',
                    style: AppTextStyles.title1Bold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _kategoriPilihan == label;
    return GestureDetector(
      onTap: () => setState(() => _kategoriPilihan = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blueDarker
              : AppColors.blueLightActive.withOpacity(0.5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: AppTextStyles.title1Bold.copyWith(
            color: isSelected ? Colors.white : AppColors.blueDarker,
          ),
        ),
      ),
    );
  }
}
