import 'package:flutter/material.dart';
import 'w_registration_email.dart';
import 'p_sign_in.dart';

class ChoosingPage extends StatefulWidget {
  const ChoosingPage({super.key});

  @override
  State<ChoosingPage> createState() => _ChoosingPageState();
}

class _ChoosingPageState extends State<ChoosingPage> {
  String? selectedRole;

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

                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRole = 'warga';
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: selectedRole == 'warga'
                          ? const Color(0xFF004E62)
                          : const Color(0xFFB0E6F3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.waves,
                          size: 40,
                          color: selectedRole == 'warga'
                              ? Colors.white
                              : const Color(0xFF004D56),
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
                                  color: selectedRole == 'warga'
                                      ? Colors.white
                                      : const Color(0xFF004D56),
                                ),
                              ),
                              Text(
                                'Laporkan masalah air dan dapatkan edukasi sanitasi air',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: selectedRole == 'warga'
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --- Card Petugas ---
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRole = 'petugas';
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: selectedRole == 'petugas'
                          ? const Color(0xFF004E62)
                          : const Color(0xFFB0E6F3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.assignment_turned_in_outlined,
                          size: 40,
                          color: selectedRole == 'petugas'
                              ? Colors.white
                              : const Color(0xFF004D56),
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
                                  color: selectedRole == 'petugas'
                                      ? Colors.white
                                      : const Color(0xFF004D56),
                                ),
                              ),
                              Text(
                                'Pantau dan tangani laporan warga',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: selectedRole == 'petugas'
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // --- Tombol Lanjut ---
                GestureDetector(
                  onTap: () {
                    // 2. Logika Navigasi Berdasarkan Pilihan
                    if (selectedRole == 'warga') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WRegistrationEmail(),
                        ),
                      );
                    } else if (selectedRole == 'petugas') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PSignIn(),
                        ),
                      );
                    } else {
                      // Kasih peringatan jika belum pilih peran
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silakan pilih peran terlebih dahulu!'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      // Tombol jadi agak transparan/abu jika belum memilih
                      color: selectedRole == null
                          ? const Color(0xFF004D56).withOpacity(0.5)
                          : const Color(0xFF004D56),
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
