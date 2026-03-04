import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'w_sign_in.dart';

class W_Homepage extends StatefulWidget {
  const W_Homepage({super.key});

  @override
  State<W_Homepage> createState() => _W_HomepageState();
}

class _W_HomepageState extends State<W_Homepage> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      setState(() {
        _userName = user.displayName!;
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
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
                  const Icon(Icons.notifications_none, size: 30, color: Color(0xFF004D56)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
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
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00838F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Keluhan Diproses',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF004D56)),
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
                    Row(
                      children: const [
                        Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF709096)),
                        SizedBox(width: 5),
                        Text('Jl. Pahlawan No.34', style: TextStyle(fontSize: 11, color: Color(0xFF709096))),
                        SizedBox(width: 15),
                        Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF709096)),
                        SizedBox(width: 5),
                        Text('12/2/2026', style: TextStyle(fontSize: 11, color: Color(0xFF709096))),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF00838F),
          unselectedItemColor: const Color(0xFF709096),
          showUnselectedLabels: true,
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active_outlined), label: 'Report'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Edukasi'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
          ],
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
              const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFF004D56)),
            ],
          ),
        ],
      ),
    );
  }
}