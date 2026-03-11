import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: P_Profil(),
  ));
}

class P_Profil extends StatelessWidget {
  const P_Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF003D45),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF003D45)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                  border: Border.all(color: const Color(0xFF008394), width: 2),
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: Color(0xFF003D45),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Budi Santoso",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003D45),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "Kabid Pengendalian Pencemaran & Kerusakan Lingkungan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF003D45),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 150),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuItem(Icons.info, "Tentang Aplikasi"),
                  const SizedBox(height: 15),
                  _buildMenuItem(Icons.logout, "Logout"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavLink(Icons.bar_chart, "Dashboard", false),
            _buildNavLink(Icons.construction, "Kegiatan", false),
            _buildNavLink(Icons.account_circle, "Akun", true),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF003D45), size: 24),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF546E7A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavLink(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF008394) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.black,
            size: 26,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}