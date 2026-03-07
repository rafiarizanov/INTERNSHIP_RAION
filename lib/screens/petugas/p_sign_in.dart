import 'package:INTERNSHIP_RAION/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../umum/choosing.dart';
import 'p_homepage.dart';

class PSignIn extends StatefulWidget {
  const PSignIn({super.key});

  @override
  State<PSignIn> createState() => _PSignInState();
}

class _PSignInState extends State<PSignIn> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controller untuk menangkap input dari user
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Menghapus controller dari memori saat page ditutup
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi Logika Login
  void _handleLogin() async {
    final nip = _nipController.text.trim();
    final password = _passwordController.text.trim();

    if (nip.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIP dan Kata Sandi wajib diisi!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Memanggil fungsi loginPetugas yang ada di AuthProvider
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProv.loginPetugas(nip, password);

    setState(() {
      _isLoading = false;
    });

    if (error == null) {
      // Jika berhasil (error kosong), pindah ke Homepage
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const P_Homepage()),
        (route) => false,
      );
    } else {
      // Jika gagal, tampilkan pesan error dari provider
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
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

                // --- AREA ILUSTRASI (SUDAH DIKEMBALIKAN) ---
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
                      'assets/image/Petugas Card.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Input NIP
                _buildPetugasInput(
                  label: "NIP Anda",
                  icon: Icons.contact_mail_outlined,
                  controller: _nipController,
                ),
                const SizedBox(height: 20),
                // Input Password
                _buildPetugasInput(
                  label: "Kata Sandi",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                ),

                const SizedBox(height: 50),

                // --- TOMBOL MASUK ---
                GestureDetector(
                  onTap: _isLoading ? null : _handleLogin,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: _isLoading ? Colors.grey : const Color(0xFF004D56),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
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

  // Widget TextField Custom
  Widget _buildPetugasInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: TextFormField(
        controller: controller,
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
