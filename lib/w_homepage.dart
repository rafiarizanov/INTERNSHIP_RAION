import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Tambahkan import Firebase
import 'w_sign_in.dart'; // 2. Tambahkan import halaman Masuk untuk fitur Logout

class W_Homepage extends StatefulWidget {
  const W_Homepage({super.key});

  @override
  State<W_Homepage> createState() => _W_HomepageState();
}

class _W_HomepageState extends State<W_Homepage> {
  // 3. Siapkan variabel untuk menampung nama
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _getUserData(); // 4. Jalankan pengambilan data saat halaman dibuka
  }

  // Fungsi untuk mengambil nama dari Firebase
  void _getUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
      setState(() {
        // Kita ambil kata pertama saja (Nama Depan) agar teksnya tidak terlalu panjang
        _userName = user.displayName!.split(' ')[0]; 
      });
    }
  }

  // Fungsi untuk Logout
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      // Hapus riwayat halaman dan tendang balik ke halaman Masuk
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Menghilangkan tombol back default
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 20,
            ),
            const SizedBox(width: 12),
            // 5. Ubah teks statis menjadi variabel _userName
            Text(
              'Hello, $_userName!', 
              style: const TextStyle(
                color: Color(0xFF888888), 
                fontSize: 14, 
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            // 6. Bungkus tombol kanan atas dengan GestureDetector untuk Logout
            child: GestureDetector(
              onTap: () {
                _logout(); // Panggil fungsi keluar saat diklik
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(8),
                ),
                // Saya ganti ikonnya jadi ikon logout agar lebih pas, 
                // tapi kamu bisa kembalikan ke Icons.stop kalau mau.
                child: const Icon(Icons.logout, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
        child: Column(
          children: [
            // Banner Utama
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            const SizedBox(height: 15),
            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 25,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 5),
                const CircleAvatar(radius: 3, backgroundColor: Color(0xFFD9D9D9)),
                const SizedBox(width: 5),
                const CircleAvatar(radius: 3, backgroundColor: Color(0xFFD9D9D9)),
                const SizedBox(width: 5),
                const CircleAvatar(radius: 3, backgroundColor: Color(0xFFD9D9D9)),
              ],
            ),
            const SizedBox(height: 30),
            // Grid Menu 2 Kolom
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 12, width: 60, color: Colors.grey[500]),
                        const SizedBox(height: 5),
                        Container(height: 10, width: 80, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 12, width: 60, color: Colors.grey[500]),
                        const SizedBox(height: 5),
                        Container(height: 10, width: 80, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            // Card List Bawah
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 12, width: double.infinity, color: Colors.grey[500]),
                        const SizedBox(height: 8),
                        Container(height: 10, width: 120, color: Colors.grey[400]),
                        const SizedBox(height: 5),
                        Container(height: 10, width: 80, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5), 
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFD9D9D9),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notification_important, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark, size: 28), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: ''),
        ],
      ),
    );
  }
}