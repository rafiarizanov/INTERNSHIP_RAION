import 'package:flutter/material.dart';
import '../warga/masuk_daftar/w_registration_email.dart';
import '../petugas/masuk/p_sign_in.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 25),
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

                // --- Card Warga ---
                GestureDetector(
                  onTap: () => setState(() => selectedRole = 'warga'),
                  child: Container(
                    width: double.infinity,
                    height:
                        180, // Tinggi kotak dibuat besar agar pas dengan desain
                    decoration: BoxDecoration(
                      color: selectedRole == 'warga'
                          ? const Color(0xFF004E62).withOpacity(0.8)
                          : const Color(0xFFB0E6F3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        // Kotak Gambar (Gede di sebelah kiri)
                        Container(
                          width: 150,
                          height: double.infinity,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/image/warga.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Teks di sebelah kanan
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 15,
                              top: 20,
                              bottom: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Warga',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: selectedRole == 'warga'
                                        ? Colors.white
                                        : const Color(0xFF004D56),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Laporkan masalah air bersih dan dapatkan edukasi terkait sanitasi.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: selectedRole == 'warga'
                                        ? Colors.white70
                                        : const Color(
                                            0xFF004D56,
                                          ).withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // --- Card Petugas ---
                GestureDetector(
                  onTap: () => setState(() => selectedRole = 'petugas'),
                  child: Container(
                    width: double.infinity,
                    height: 180, // Tinggi sama agar seragam
                    decoration: BoxDecoration(
                      color: selectedRole == 'petugas'
                          ? const Color(0xFF004E62).withOpacity(0.8)
                          : const Color(0xFFB0E6F3),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        // Kotak Gambar
                        Container(
                          width: 150,
                          height: double.infinity,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/image/petugas.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Teks
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 15,
                              top: 20,
                              bottom: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Petugas',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: selectedRole == 'petugas'
                                        ? Colors.white
                                        : const Color(0xFF004D56),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pantau dan tangani laporan warga terkait masalah air bersih.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: selectedRole == 'petugas'
                                        ? Colors.white70
                                        : const Color(
                                            0xFF004D56,
                                          ).withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // --- Tombol Lanjut ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Silakan pilih peran!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003D45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Lanjut',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
