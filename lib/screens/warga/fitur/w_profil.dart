import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfilPage(),
    );
  }
}

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  // Warna tema sesuai gambar
  final Color primaryTeal = const Color(0xFF004D56);
  final Color lightTeal = const Color(0xFF00838F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Akun dan Profil',
          style: TextStyle(
            color: primaryTeal,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: primaryTeal),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Foto Profil dengan border tipis (opsional)
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: const NetworkImage(
                  'https://i.pravatar.cc/300',
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Siti Aisyah',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryTeal,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              'Warga',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryTeal,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cake_outlined,
                  size: 16,
                  color: primaryTeal.withOpacity(0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  '14/08/1986',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryTeal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildMenuItem(Icons.edit, 'Edit Profil'),
                  const SizedBox(height: 12),
                  _buildMenuItem(Icons.info, 'Tentang Aplikasi'),
                  const SizedBox(height: 12),
                  _buildMenuItem(Icons.logout, 'Logout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryTeal, size: 28),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: primaryTeal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        isActive
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: lightTeal,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: Colors.white),
              )
            : Icon(icon, color: Colors.black54),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? primaryTeal : Colors.black54,
          ),
        ),
      ],
    );
  }
}
