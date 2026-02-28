import 'package:flutter/material.dart';

class WHome extends StatelessWidget {
  const WHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE), // Warna background abu muda sesuai gambar
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Profil & Notif
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey, // Lingkaran profil abu-abu
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Hello, User!',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25),

              // Banner Besar Abu-abu
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 10),

              // Indikator Titik (Page Indicator)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 20, height: 4, decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 4),
                  const CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                  const SizedBox(width: 4),
                  const CircleAvatar(radius: 3, backgroundColor: Colors.grey),
                ],
              ),
              const SizedBox(height: 25),

              // Dua Menu Kotak
              Row(
                children: [
                  Expanded(child: _buildSquareMenu()),
                  const SizedBox(width: 15),
                  Expanded(child: _buildSquareMenu()),
                ],
              ),
              const SizedBox(height: 25),

              // List Item Bawah
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(10))),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 150, height: 12, color: Colors.grey[500]),
                        const SizedBox(height: 8),
                        Container(width: 100, height: 12, color: Colors.grey[500]),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active, color: Colors.black), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark, color: Colors.black), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.black), label: ''),
        ],
      ),
    );
  }

  // Widget bantuan untuk menu kotak
  Widget _buildSquareMenu() {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 60, height: 10, color: Colors.grey[500]),
          const SizedBox(height: 6),
          Container(width: 90, height: 10, color: Colors.grey[500]),
        ],
      ),
    );
  }
}