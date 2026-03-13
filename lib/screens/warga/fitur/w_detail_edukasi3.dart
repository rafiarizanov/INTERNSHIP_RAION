import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class WEdukasiDetail3 extends StatelessWidget {
  const WEdukasiDetail3({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Langkah Kecil yang Penting 🧼',
              style: AppTextStyles.h3Bold.copyWith(
                color: AppColors.blueDarker,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Mencuci tangan dengan sabun dapat mencegah hingga 50% penyakit yang ditularkan melalui air.',
              style: AppTextStyles.title1Bold.copyWith(
                color: AppColors.blueDark,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage('assets/image/materi3.jpg'), // Pastikan di w_edukasi path-nya juga /image/materi3.jpg
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 16),
            _buildBodyText(
              'Akses terhadap air bersih harus selalu diiringi dengan praktik sanitasi yang baik. Salah satu langkah paling sederhana namun paling berdampak dalam dunia medis adalah mencuci tangan menggunakan sabun.',
            ),
            const SizedBox(height: 16),
            _buildSubHeading('1. Mengapa Air Saja Tidak Cukup?'),
            _buildBodyText(
              'Membilas tangan hanya dengan air tidak bisa membunuh kuman. Struktur virus dan kuman dilapisi oleh lapisan lemak (lipid). Kandungan kimia pada sabun bekerja secara aktif menghancurkan lapisan lemak tersebut, sehingga virus hancur dan luruh terbawa air.',
            ),
            const SizedBox(height: 16),
            _buildSubHeading('2. Efektivitas Mencegah Penyakit'),
            _buildBodyText(
              'Menurut data WHO (Organisasi Kesehatan Dunia), kebiasaan mencuci tangan dengan air mengalir dan sabun dapat mengurangi risiko penyakit saluran pernapasan hingga 20% dan penyakit diare hingga 50%.',
            ),
            const SizedBox(height: 16),
            _buildSubHeading('3. Momen Krusial Cuci Tangan'),
            _buildBodyText(
              'Kuman sangat mudah berpindah. Pastikan Anda selalu mencuci tangan pada momen-momen berikut:',
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Sebelum, selama, dan sesudah menyiapkan makanan.'),
            _buildBulletPoint('Sebelum makan.'),
            _buildBulletPoint('Setelah menggunakan toilet atau membuang popok anak.'),
            _buildBulletPoint('Setelah menyentuh hewan atau membersihkan sampah rumah tangga.'),
            const SizedBox(height: 16),
            _buildBodyText(
              'Terapkan langkah kecil ini dalam keluarga Anda. Ingat, menggosok tangan dengan sabun selama minimal 20 detik bisa menyelamatkan nyawa.',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) => Text(
        text,
        style: AppTextStyles.body.copyWith(color: Colors.black87, height: 1.5),
      );
  Widget _buildSubHeading(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: AppTextStyles.title2Bold.copyWith(
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      );
  Widget _buildBulletPoint(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '•  ',
              style: AppTextStyles.title1Bold.copyWith(color: Colors.black87),
            ),
            Expanded(child: _buildBodyText(text)),
          ],
        ),
      );
}