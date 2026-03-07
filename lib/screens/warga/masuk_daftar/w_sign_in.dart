import 'package:INTERNSHIP_RAION/screens/umum/choosing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'w_registration_email.dart';
import '../fitur/w_homepage.dart';
import 'w_OTP.dart';

class WSignIn extends StatefulWidget {
  const WSignIn({super.key});

  @override
  State<WSignIn> createState() => _WSignInState();
}

class _WSignInState extends State<WSignIn> {
  bool _isPhoneMode = false;
  bool _isLoading = false;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF709096)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF004D56)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: authProv.form,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const ChoosingPage()),
                            (route) => false,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF004D56),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/image/logo.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  const Text(
                    'Masuk Sebagai Warga',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D56),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkan nomor telepon atau email\nserta kata sandi Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF004D56)),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPhoneMode = true),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: _isPhoneMode ? const Color(0xFF004D56) : const Color(0xFFB0E6F3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Gunakan No. Telp',
                                style: TextStyle(
                                  color: _isPhoneMode ? Colors.white : const Color(0xFF004D56),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPhoneMode = false),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: !_isPhoneMode ? const Color(0xFF004D56) : const Color(0xFFB0E6F3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Gunakan Email',
                                style: TextStyle(
                                  color: !_isPhoneMode ? Colors.white : const Color(0xFF004D56),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  if (_isPhoneMode)
                    _buildTextField('Nomor Telepon', Icons.phone_outlined, _phoneController)
                  else
                    _buildTextField('Email', Icons.email_outlined, _emailController),
                  _buildTextField('Kata Sandi', Icons.lock_outline, _passwordController, isPassword: true),
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun? ', style: TextStyle(fontSize: 13)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const WRegistrationEmail()),
                          );
                        },
                        child: const Text(
                          'Daftar di sini',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      if (!_isPhoneMode) {
                        authProv.islogin = true;
                        authProv.enteredEmail = _emailController.text.trim();
                        authProv.enteredPassword = _passwordController.text.trim();
                        
                        setState(() => _isLoading = true);
                        final errorMessage = await authProv.submit();
                        setState(() => _isLoading = false);

                        if (!context.mounted) return;
                        if (errorMessage == null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const W_Homepage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
                          );
                        }
                      } else {
                        if (_phoneController.text.isEmpty) return;
                        setState(() => _isLoading = true);
                        await authProv.sendPhoneOTP(
                          phone: _phoneController.text.trim(),
                          onSuccess: () {
                            setState(() => _isLoading = false);
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
                          onError: (err) {
                            setState(() => _isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(err), backgroundColor: Colors.red),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}