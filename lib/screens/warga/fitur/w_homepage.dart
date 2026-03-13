import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/services/warga_service.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_detail_edukasi1.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_edukasi.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_profil.dart';
import 'package:flutter/material.dart';
import 'w_notifikasi.dart';
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
      HalamanBerandaUtama(key: UniqueKey(), onTabChange: _pindahTab),
      const W_ReportPage(),
      const RiwayatLaporanPage(),
      const WProfil(),
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
          color: isSelected ? AppColors.blueDark : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black87,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: isSelected
                  ? AppTextStyles.bodyBold.copyWith(color: Colors.white)
                  : AppTextStyles.bodyMid.copyWith(color: Colors.black87),
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
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }


  Future<void> _getUserData() async {
    final userData = await WargaService().getUserProfile();
    if (mounted && userData.isNotEmpty) {
      setState(() {
        _userName = userData['name'];
        _avatarUrl = userData['avatar_url'];
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchLatestReports() async {
    return await WargaService().fetchLatestReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _getUserData,
        color: AppColors.blueDarker,
        backgroundColor: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _avatarUrl.isNotEmpty
                              ? NetworkImage(_avatarUrl)
                              : null,
                          child: _avatarUrl.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.grey.shade600,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo,',
                              style: AppTextStyles.title1.copyWith(
                                color: AppColors.blueDarker,
                              ),
                            ),
                            Text(
                              _userName,
                              style: AppTextStyles.h1Bold.copyWith(
                                color: AppColors.blueDarker,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        size: 30,
                        color: AppColors.blueDarker,
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

                Text(
                  'Edukasi Hari Ini',
                  style: AppTextStyles.title2Bold.copyWith(
                    color: AppColors.blueDarker,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.blueLightActive.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3 Tanda Air Sumur Anda Bermasalah 💧',
                        style: AppTextStyles.title2Bold.copyWith(
                          color: AppColors.blueDarker,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Segera laporkan jika air berbau tidak wajar, berubah warna, atau terasa licin di kulit.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.blueDarker,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WEdukasiDetail1(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueDarker,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Baca Selengkapnya',
                                style: AppTextStyles.bodyBold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                Text(
                  'Tindakan Cepat',
                  style: AppTextStyles.title2Bold.copyWith(
                    color: AppColors.blueDarker,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        'Buat Laporan Air',
                        Icons.campaign,
                        () => widget.onTabChange(1),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildActionCard(
                        'Edukasi Air Bersih',
                        Icons.menu_book_outlined,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WEdukasi(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                Text(
                  'Laporan Terbaru',
                  style: AppTextStyles.title2Bold.copyWith(
                    color: AppColors.blueDarker,
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
                            color: AppColors.blueDarker,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError)
                      return const Text("Terjadi kesalahan memuat laporan.");

                    final reports = snapshot.data ?? [];
                    if (reports.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            "Belum ada laporan yang dibuat.",
                            style: AppTextStyles.body.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: reports
                          .map(
                            (report) => Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: _buildLatestReportCard(report),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
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
                color: AppColors.blueLightActive.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.blueDarker, size: 28),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyBold.copyWith(
                      color: AppColors.blueDarker,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.blueDarker,
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
    Color statusBgColor = AppColors.statusBelumDibacaBg;
    Color statusTextColor = AppColors.statusBelumDibacaText;

    if (status == 'Laporan Dibaca') {
      statusBgColor = AppColors.statusDibacaBg;
      statusTextColor = AppColors.statusDibacaText;
    } else if (status == 'Laporan Diproses') {
      statusBgColor = AppColors.statusDiprosesBg;
      statusTextColor = AppColors.statusDiprosesText;
    } else if (status == 'Laporan Selesai') {
      statusBgColor = AppColors.statusSelesaiBg;
      statusTextColor = AppColors.statusSelesaiText;
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
                    style: AppTextStyles.captionBold.copyWith(
                      color: statusTextColor,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  size: 20,
                  color: AppColors.blueDarker,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              judulLaporan,
              style: AppTextStyles.title2Bold.copyWith(
                color: AppColors.blueDarker,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              deskripsiAsli,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                color: AppColors.blueDark,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: AppColors.blueDarker,
                ),
                const SizedBox(width: 4),
                Text(
                  report['lokasi'] ?? '-',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.blueDarker,
                  ),
                ),
                const SizedBox(width: 24),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.blueDarker,
                ),
                const SizedBox(width: 4),
                Text(
                  report['tanggal'] ?? '-',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.blueDarker,
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
  