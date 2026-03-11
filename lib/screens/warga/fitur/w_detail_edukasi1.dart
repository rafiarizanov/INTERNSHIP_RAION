import 'package:flutter/material.dart';

class WEdukasiDetail1 extends StatelessWidget {
  const WEdukasiDetail1({super.key});

  final Color primaryTeal = const Color(0xFF003D4C);
  final Color textDark = const Color(0xFF1A1A1A);

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
                  color: primaryTeal,
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
              style: TextStyle(
                color: primaryTeal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
              'Tiga Hal Ini Menandakan Air Sumur Anda Bermasalah',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: primaryTeal,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'Penting untuk mengenali tanda-tanda ini agar dapat segera mengambil tindakan.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF387A89),
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
                  image: NetworkImage('assets/image/materi1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Divider(color: Colors.grey[300], thickness: 1),

            const SizedBox(height: 16),

            _buildBodyText(
              'Air sumur sering digunakan sebagai sumber air sehari-hari. Namun, kualitasnya bisa berubah karena pencemaran dari lingkungan sekitar. Penting untuk mengenali tanda-tanda air sumur yang bermasalah agar dapat segera mengambil tindakan.',
            ),
            const SizedBox(height: 16),

            _buildSubHeading('1. Air Berbau Tidak Sedap'),
            _buildBodyText(
              'Jika air sumur mengeluarkan bau seperti bau tanah, belerang, atau bau busuk, hal ini bisa menjadi tanda adanya kontaminasi bakteri atau zat tertentu di dalam air.',
            ),
            const SizedBox(height: 16),

            _buildSubHeading('2. Air Berubah Warna'),
            _buildBodyText(
              'Air sumur yang sehat biasanya jernih dan tidak berwarna. Jika air terlihat keruh, kekuningan, atau kecokelatan, kemungkinan terdapat kandungan logam, lumpur, atau kotoran yang masuk ke dalam sumur.',
            ),
            const SizedBox(height: 16),

            _buildSubHeading('3. Menyebabkan Iritasi atau Gangguan Kesehatan'),
            _buildBodyText(
              'Air yang terkontaminasi dapat menyebabkan gatal pada kulit, diare, atau gangguan kesehatan lainnya jika digunakan untuk mandi atau diminum.',
            ),
            const SizedBox(height: 16),

            _buildSubHeading('Apa yang Harus Dilakukan?'),
            _buildBodyText(
              'Jika Anda menemukan tanda-tanda di atas, sebaiknya:',
            ),
            const SizedBox(height: 8),

            _buildBulletPoint('Hindari menggunakan air tersebut untuk minum.'),
            _buildBulletPoint(
              'Periksa kondisi sumur dan lingkungan sekitarnya.',
            ),
            _buildBulletPoint(
              'Laporkan kondisi tersebut melalui aplikasi agar dapat ditindaklanjuti.',
            ),
            const SizedBox(height: 16),

            _buildBodyText(
              'Dengan mengenali tanda-tanda ini lebih awal, Anda dapat membantu menjaga kesehatan keluarga dan lingkungan sekitar.',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: textDark.withOpacity(0.9),
        height: 1.5,
      ),
    );
  }

  Widget _buildSubHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: textDark,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          Expanded(child: _buildBodyText(text)),
        ],
      ),
    );
  }
}
