import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class WEdukasiDetail2 extends StatelessWidget {
  const WEdukasiDetail2({super.key});

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
              'Air Jernih Belum Tentu Aman 🔍',
              style: AppTextStyles.h3Bold.copyWith(
                color: AppColors.blueDarker,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Air yang terlihat bening bisa saja mengandung bakteri dan zat kimia berbahaya.',
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
                  image: AssetImage('assets/image/materi2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 16),
            _buildBodyText(
              'Banyak masyarakat yang masih beranggapan bahwa air sumur yang jernih, tidak berbau, dan tidak berasa sudah pasti 100% aman untuk dikonsumsi. Sayangnya, ini adalah mitos yang bisa membahayakan kesehatan.',
            ),
            const SizedBox(height: 16),
            _buildSubHeading('1. Bakteri Tak Kasat Mata (E. coli)'),
            _buildBodyText(
              'Jarak antara sumur dan tangki septik (septic tank) yang terlalu dekat (kurang dari 10 meter) dapat menyebabkan bakteri E. coli atau Coliform meresap ke dalam air tanah. Bakteri ini tidak mengubah warna air, namun dapat memicu wabah diare hingga kolera.',
            ),
            const SizedBox(height: 16),
            _buildSubHeading('2. Pencemaran Logam Berat'),
            _buildBodyText(
              'Air yang jernih juga bisa mengandung logam berat seperti timbal, arsenik, atau sisa pestisida dari aktivitas industri dan pertanian di sekitar pemukiman. Paparan jangka panjang zat ini sangat beracun bagi ginjal dan saraf.',
            ),
            const SizedBox(height: 16),
            _buildSubHeading('3. Tingkat Keasaman (pH) Air'),
            _buildBodyText(
              'Air yang bening bisa memiliki tingkat pH yang terlalu asam atau terlalu basa. Air asam dapat mengikis pipa saluran air rumah Anda dan memicu iritasi pada kulit sensitif.',
            ),
            const SizedBox(height: 16),
            _buildSubHeading('Langkah Pencegahan yang Tepat:'),
            const SizedBox(height: 8),
            _buildBulletPoint('Selalu rebus air sumur hingga mendidih sempurna (minimal 100°C selama 1-3 menit) sebelum diminum.'),
            _buildBulletPoint('Lakukan pengujian sampel air sumur Anda ke laboratorium dinas kesehatan terdekat setidaknya 1 tahun sekali.'),
            _buildBulletPoint('Jika menduga ada pencemaran limbah di sekitar pemukiman, segera buat laporan melalui aplikasi ini.'),
            const SizedBox(height: 16),
            _buildBodyText(
              'Kewaspadaan adalah kunci. Jangan mudah tertipu oleh tampilan air yang sekadar jernih di mata.',
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