import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'w_detail_laporan.dart';

class RiwayatLaporanPage extends StatefulWidget {
  const RiwayatLaporanPage({super.key});

  @override
  State<RiwayatLaporanPage> createState() => _RiwayatLaporanPageState();
}

class _RiwayatLaporanPageState extends State<RiwayatLaporanPage> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> fetchReports() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('reports')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Warna background abu-abu terang
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        automaticallyImplyLeading:
            false, // Menghilangkan tombol back default jika ini tab utama
        title: const Text(
          'Riwayat Laporan',
          style: TextStyle(
            color: Color(0xFF003D4C),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF003D4C)),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final reports = snapshot.data ?? [];

          if (reports.isEmpty) {
            return const Center(
              child: Text(
                'Anda belum memiliki riwayat laporan.',
                style: TextStyle(color: Color(0xFF003D4C)),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return _buildReportCard(context, report);
            },
          );
        },
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Map<String, dynamic> report) {
    // 1. Aturan Warna Status Sesuai Desain
    String status = report['status'] ?? 'Belum Dibaca';
    Color statusBgColor = Colors.grey.shade300;
    Color statusTextColor = Colors.grey.shade800;

    if (status == 'Laporan Dibaca') {
      statusBgColor = const Color(0xFFBDE7F1);
      statusTextColor = const Color(0xFF00838F);
    } else if (status == 'Laporan Diproses') {
      statusBgColor = const Color(0xFFFFF1AD);
      statusTextColor = const Color(0xFFB48A00);
    } else if (status == 'Laporan Selesai') {
      statusBgColor = const Color(0xFFC8E6C9);
      statusTextColor = const Color(0xFF2E7D32);
    } else if (status == 'Belum Dibaca') {
      statusBgColor = const Color(0xFFE0E0E0);
      statusTextColor = const Color(0xFF616161);
    }

    // 2. Simulasi Judul Laporan (Karena di form tidak ada input Judul)
    // Kita ambil 3-4 kata pertama dari deskripsi sebagai Judul Bayangan
    String deskripsiAsli = report['deskripsi'] ?? 'Tidak ada deskripsi';
    List<String> kataDeskripsi = deskripsiAsli.split(' ');
    String judulLaporan = kataDeskripsi.length > 4
        ? "${kataDeskripsi.sublist(0, 4).join(' ')}..."
        : deskripsiAsli;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => W_DetailLaporan(report: report),
          ),
        );
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.5,
          ), // Garis tepi halus
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02), // Bayangan sangat tipis
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARIS ATAS: Badge Status & Ikon Panah
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // Melengkung penuh (pill)
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right, // Ikon panah yang lebih tumpul
                  size: 20,
                  color: Color(0xFF003D4C),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // JUDUL
            Text(
              judulLaporan,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003D4C),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            // DESKRIPSI
            Text(
              deskripsiAsli,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF00838F),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // BARIS BAWAH: Lokasi & Tanggal
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: Color(0xFF003D4C),
                ),
                const SizedBox(width: 4),
                Text(
                  report['lokasi'] ?? '-',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF003D4C),
                  ),
                ),
                const SizedBox(width: 24), // Jarak antar ikon
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Color(0xFF003D4C),
                ),
                const SizedBox(width: 4),
                Text(
                  report['tanggal'] ?? '-',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF003D4C),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
