import 'package:flutter/material.dart';
import 'w_registration_email.dart';

class ChoosingPage extends StatefulWidget {
  const ChoosingPage({super.key});

  @override
  State<ChoosingPage> createState() => _ChoosingPageState();
}

class _ChoosingPageState extends State<ChoosingPage> {
  bool isHoverWarga = false;
  bool isHoverPetugas = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Pilih Peran Anda',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D56),
                  ),
                ),
                const SizedBox(height: 40),

                // --- Card Warga ---
                MouseRegion(
                  onEnter: (_) => setState(() => isHoverWarga = true),
                  onExit: (_) => setState(() => isHoverWarga = false),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WRegistrationEmail()),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        // Warna Dasar B0E6F3, pas Hover jadi 004E62
                        color: isHoverWarga 
                            ? const Color(0xFF004E62) 
                            : const Color(0xFFB0E6F3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.waves, 
                            size: 40, 
                            color: isHoverWarga ? Colors.white : const Color(0xFF004D56)
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Warga',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isHoverWarga ? Colors.white : const Color(0xFF004D56),
                                  ),
                                ),
                                Text(
                                  'Laporkan masalah air dan dapatkan edukasi sanitasi air',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isHoverWarga ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Card Petugas ---
                MouseRegion(
                  onEnter: (_) => setState(() => isHoverPetugas = true),
                  onExit: (_) => setState(() => isHoverPetugas = false),
                  child: GestureDetector(
                    onTap: () => print("Ke Halaman Petugas"),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isHoverPetugas 
                            ? const Color(0xFF004E62) 
                            : const Color(0xFFB0E6F3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.assignment_turned_in_outlined, 
                            size: 40, 
                            color: isHoverPetugas ? Colors.white : const Color(0xFF004D56)
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Petugas',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isHoverPetugas ? Colors.white : const Color(0xFF004D56),
                                  ),
                                ),
                                Text(
                                  'Pantau dan tangani laporan warga',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isHoverPetugas ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // --- Tombol Lanjut ---
                GestureDetector(
                  onTap: () => print("Lanjut"),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF004D56),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        'Lanjut',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}