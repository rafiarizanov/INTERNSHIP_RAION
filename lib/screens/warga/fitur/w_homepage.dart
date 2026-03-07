import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_edit_profile.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_report.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_riwayat_laporan.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../masuk_daftar/w_sign_in.dart';

class W_Homepage extends StatefulWidget {
  const W_Homepage({super.key});

  @override
  State<W_Homepage> createState() => _W_HomepageState();
}

class _W_HomepageState extends State<W_Homepage> {
  int _indexSekarang = 0;

  final List<Widget> _pages = [
    const HalamanBerandaUtama(),
    const W_ReportPage(),
    const RiwayatLaporanPage(),
    const W_EditProfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_indexSekarang],

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
      onTap: () {
        setState(() {
          _indexSekarang = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00838F) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              // Warna ikon: Putih kalau diklik, hitam/gelap kalau tidak
              color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                // Warna teks mengikuti status klik
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
  const HalamanBerandaUtama({super.key});

  @override
  State<HalamanBerandaUtama> createState() => _HalamanBerandaUtamaState();
}

class _HalamanBerandaUtamaState extends State<HalamanBerandaUtama> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final displayName = user.userMetadata?['display_name'] as String?;
      if (displayName != null && displayName.isNotEmpty) {
        setState(() {
          _userName = displayName;
        });
      }
    }
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WSignIn()),
        (route) => false,
      );
    }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
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
                            '$_userName!',
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
                  const Icon(
                    Icons.notifications_none,
                    size: 30,
                    color: Color(0xFF004D56),
                  ),
                ],
              ),
              const SizedBox(height: 25),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3 Tanda Air Sumur Anda Bermasalah 🚨',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D56),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Segera laporkan jika air berbau tidak wajar, berubah warna (kuning/coklat/kehijauan), atau terasa licin di kulit.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF004D56)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
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
                  Expanded(child: _buildActionCard('Buat Laporan Air')),
                  const SizedBox(width: 15),
                  Expanded(child: _buildActionCard('Edukasi Air Bersih')),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                'Laporan Terakhir',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D56),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
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
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00838F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Keluhan Diproses',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Color(0xFF004D56),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Air Menguning',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D56),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Air berwarna kuning kecoklatan dan meninggalkan noda pada pakaian setelah dicuci.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF709096)),
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Color(0xFF709096),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Jl. Pahlawan No.34',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF709096),
                          ),
                        ),
                        SizedBox(width: 15),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Color(0xFF709096),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '12/2/2026',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF709096),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
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
    );
  }
}
