import 'package:INTERNSHIP_RAION/choosing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'w_registration_email.dart';
import 'w_homepage.dart';
import 'w_OTP.dart';

class WSignIn extends StatefulWidget {
  const WSignIn({super.key});

  @override
  State<WSignIn> createState() => _WSignInState();
}

class _WSignInState extends State<WSignIn> {
  bool _ingatSaya = false;

  // Variabel untuk mendeteksi apakah pengguna memilih tab Nomor HP
  bool _isPhoneMode = false;
  bool _isLoading = false;

  // Controller khusus untuk Nomor HP
  final TextEditingController _phoneController = TextEditingController();

  Widget _buildInputBox(
    String label, {
    bool isPassword = false,
    void Function(String?)? onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF004D56),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFB0E6F3).withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFB0E6F3)),
          ),
          child: TextFormField(
            obscureText: isPassword,
            onSaved: onSaved,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Bagian ini tidak boleh kosong';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF004D56),
            size: 20,
          ),
          onPressed: () {
            // <-- 2. Ubah fungsi back untuk menyapu bersih tumpukan dan mereset ke ChoosingPage
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ChoosingPage()),
              (route) => false,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: authProv.form,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D56),
                  ),
                ),
                const SizedBox(height: 30),

                // --- TAB SELEKTOR EMAIL / NOMOR HP ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isPhoneMode = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 130,
                        height: 45,
                        decoration: BoxDecoration(
                          color: !_isPhoneMode
                              ? const Color(0xFF004E62)
                              : const Color(0xFFB0E6F3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: !_isPhoneMode
                                  ? Colors.white
                                  : const Color(0xFF004D56),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => setState(() => _isPhoneMode = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 130,
                        height: 45,
                        decoration: BoxDecoration(
                          color: _isPhoneMode
                              ? const Color(0xFF004E62)
                              : const Color(0xFFB0E6F3),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            'Nomor HP',
                            style: TextStyle(
                              color: _isPhoneMode
                                  ? Colors.white
                                  : const Color(0xFF004D56),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- FORM INPUT ---
                // Jika Mode Email terpilih
                if (!_isPhoneMode) ...[
                  _buildInputBox(
                    'Email',
                    onSaved: (val) => authProv.enteredEmail = val!,
                  ),
                  const SizedBox(height: 20),
                  _buildInputBox(
                    'Kata sandi',
                    isPassword: true,
                    onSaved: (val) => authProv.enteredPassword = val!,
                  ),
                  const SizedBox(height: 15),

                  // Lupa Sandi & Ingat Saya
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              activeColor: const Color(0xFF004D56),
                              value: _ingatSaya,
                              onChanged: (value) =>
                                  setState(() => _ingatSaya = value!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Ingat saya',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Lupa kata sandi?',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004D56),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
                // Jika Mode Nomor HP terpilih
                else ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nomor HP (Contoh: 0812...)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF004D56),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0E6F3).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFFB0E6F3)),
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],

                const SizedBox(height: 50),

                // --- TOMBOL MASUK ---
                GestureDetector(
                  onTap: () async {
                    if (!_isPhoneMode) {
                      // LOGIKA LOGIN EMAIL
                      authProv.islogin = true;
                      final errorMessage = await authProv.submit();
                      if (!context.mounted) return;

                      if (errorMessage == null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const W_Homepage(),
                          ),
                        );
                      } else {
                        String pesanError = errorMessage;
                        if (errorMessage.contains('invalid-credential'))
                          pesanError = 'Email atau Kata sandi salah.';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(pesanError),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      // LOGIKA LOGIN NOMOR HP
                      if (_phoneController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Masukkan nomor HP Anda!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      setState(() => _isLoading = true);

                      await authProv.sendPhoneOTP(
                        phone: _phoneController.text.trim(),
                        onSuccess: () {
                          setState(() => _isLoading = false);
                          // Pindah ke OTP dengan penanda isLogin: true
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WOtp(
                                phoneNumber: _phoneController.text,
                                isLogin: true,
                              ),
                            ),
                          );
                        },
                        onError: (pesanError) {
                          setState(() => _isLoading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(pesanError),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    }
                  },
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

                const SizedBox(height: 30),

                // Navigasi ke Halaman Daftar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WRegistrationEmail(),
                          ),
                        );
                      },
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D56),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
