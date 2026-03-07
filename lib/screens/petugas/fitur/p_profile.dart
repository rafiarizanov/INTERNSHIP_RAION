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
          'Profil',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.stop, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Profil: Foto, Nama, dan Tombol Edit
            Row(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xFF9E9E9E),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 18, width: 120, color: const Color(0xFFD9D9D9)),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 80, color: const Color(0xFFD9D9D9)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "Edit",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 15),
            const Divider(thickness: 1, color: Color(0xFFD9D9D9)),
            const SizedBox(height: 25),

            
            _buildProfileMenu(),
            _buildProfileMenu(),
            _buildProfileMenu(),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFD9D9D9),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 2, // Highlight menu Profil
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), 
            label: 'Dashboard'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined), 
            label: 'Kegiatan'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Profil'
          ),
        ],
      ),
    );
  }

  
  Widget _buildProfileMenu() {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}