import 'package:flutter/material.dart';
import 'choosing.dart'; // Pastikan path ini benar
import 'p_homepage.dart'; // Pastikan path ini benar

class PSignIn extends StatefulWidget {
  const PSignIn({super.key});

  @override
  State<PSignIn> createState() => _PSignInState();
}

class _PSignInState extends State<PSignIn> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ChoosingPage()),
                (route) => false,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF004D56),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Masuk Sebagai Petugas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D56),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Gunakan NIP Anda beserta kata sandi yang\ntelah diberikan untuk dapat masuk.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF004D56),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // --- AREA ILUSTRASI ---
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB0E6F3).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFB0E6F3),
                      width: 4,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/image/Petugas Card.png', // GANTI KE ASSET
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                _buildPetugasInput(
                  label: "NIP Anda",
                  icon: Icons.contact_mail_outlined,
                ),
                const SizedBox(height: 20),
                _buildPetugasInput(
                  label: "Kata Sandi",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 50),

                // --- TOMBOL MASUK (FIXED) ---
                GestureDetector(
                  onTap: () {
                    // Pindah ke Homepage Petugas
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const P_Homepage(),
                      ),
                    );
                  }, // TUTUP FUNGSI DI SINI
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF004D56),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Masuk',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetugasInput({
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF004D56)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
