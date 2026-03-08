import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'w_notifikasi.dart';
import '../masuk_daftar/w_sign_in.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_edit_profile.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_report.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_riwayat_laporan.dart';
import 'w_detail_laporan.dart';

class W_Homepage extends StatefulWidget {
  const W_Homepage({super.key});

  @override
  State<W_Homepage> createState() => _W_HomepageState();
}

class _W_HomepageState extends State<W_Homepage> {
  int _indexSekarang = 0;

  void _pindahTab(int index) {
    setState(() {
      _indexSekarang = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HalamanBerandaUtama(onTabChange: _pindahTab),
      const W_ReportPage(),
      const RiwayatLaporanPage(),
      const W_EditProfil(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_indexSekarang],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.home_outlined, 'Home'),
              _buildNavItem(1, Icons.campaign, 'Report'),
              _buildNavItem(2, Icons.history, 'Riwayat'),
              _buildNavItem(3, Icons.account_circle_outlined, 'Akun'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _indexSekarang == index;

    return GestureDetector(
      onTap: () => _pindahTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00838F) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HalamanBerandaUtama extends StatefulWidget {
  final Function(int) onTabChange;

  const HalamanBerandaUtama({super.key, required this.onTabChange});

  @override
  State<HalamanBerandaUtama> createState() => _HalamanBerandaUtamaState();
}

class _HalamanBerandaUtamaState extends State<HalamanBerandaUtama> {
  String _userName = 'Warga';
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final displayName = user.userMetadata?['display_name'] as String?;
      if (displayName != null && displayName.isNotEmpty) {
        setState(() {
          _userName = displayName;
        });
      }
    }
  }

  // --- MENGUBAH FUNGSI UNTUK MENARIK 2 LAPORAN ---
  Future<List<Map<String, dynamic>>> fetchLatestReports() async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('reports')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(2); // Ambil 2 laporan terbaru

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/image/logo.png'),
                        backgroundColor: Color(0xFFD9D9D9),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Halo,',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF004D56),
                            ),
                          ),
                          Text(
                            _userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004D56),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // --- TOMBOL NOTIFIKASI BARU ---
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none,
                      size: 30,
                      color: Color(0xFF004D56),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- EDUKASI HARI INI ---
              const Text(
                'Edukasi Hari Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D56),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '3 Tanda Air Sumur Anda Bermasalah 🚨',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D56),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Segera laporkan jika air berbau tidak wajar, berubah warna, atau terasa licin di kulit.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF004D56)),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Baca Selengkapnya',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // --- TINDAKAN CEPAT ---
              const Text(
                'Tindakan Cepat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D56),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'Buat Laporan Air',
                      Icons.campaign,
                      () {
                        widget.onTabChange(1);
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildActionCard(
                      'Edukasi Air Bersih',
                      Icons.menu_book_outlined,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Fitur Edukasi belum tersedia"),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- LAPORAN TERBARU (SEKARANG MENAMPILKAN 2) ---
              const Text(
                'Laporan Terbaru',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D56),
                ),
              ),
              const SizedBox(height: 12),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchLatestReports(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(
                          color: Color(0xFF004D56),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text("Terjadi kesalahan memuat laporan.");
                  }

                  final reports = snapshot.data ?? [];

                  if (reports.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "Belum ada laporan yang dibuat.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  // Menggunakan Column untuk menampilkan daftar kartu laporan secara berurutan
                  return Column(
                    children: reports.map((report) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 15.0,
                        ), // Jarak antar kartu
                        child: _buildLatestReportCard(report),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF004D56), size: 28),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D56),
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF004D56),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestReportCard(Map<String, dynamic> report) {
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

    String deskripsiAsli = report['deskripsi'] ?? 'Tidak ada deskripsi';
    List<String> kataDeskripsi = deskripsiAsli.split(' ');
    String judulLaporan = kataDeskripsi.length > 4
        ? "${kataDeskripsi.sublist(0, 4).join(' ')}..."
        : deskripsiAsli;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => W_DetailLaporan(report: report),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    borderRadius: BorderRadius.circular(20),
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
                  Icons.keyboard_arrow_right,
                  size: 20,
                  color: Color(0xFF003D4C),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
                const SizedBox(width: 24),
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
