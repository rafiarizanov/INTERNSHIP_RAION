import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'w_registration_phone.dart';
import 'w_sign_in.dart';
import 'w_homepage.dart';

class WRegistrationEmail extends StatefulWidget {
  const WRegistrationEmail({super.key});

  @override
  State<WRegistrationEmail> createState() => _WRegistrationEmailState();
}

class _WRegistrationEmailState extends State<WRegistrationEmail> {
  Widget _buildTextField(
    String hint,
    IconData icon, {
    bool isPassword = false,
    void Function(String?)? onSaved,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF709096)),
      ),
      child: TextFormField(
        obscureText: isPassword,
        onSaved: onSaved,
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
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF004D56),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/image/logo.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  const Text(
                    'Daftar Sebagai Warga',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D56),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WRegistrationPhone()),
                            );
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB0E6F3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text(
                                'Gunakan No. Telp',
                                style: TextStyle(
                                  color: Color(0xFF004D56),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF004D56),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              'Gunakan Email',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Email',
                    Icons.email_outlined,
                    onSaved: (val) => authProv.enteredEmail = val!,
                  ),
                  _buildTextField(
                    'Nama Depan',
                    Icons.person_add_alt_1_outlined,
                    onSaved: (val) => authProv.enteredFirstName = val!,
                  ),
                  _buildTextField(
                    'Nama Belakang',
                    Icons.person_add_alt_1_outlined,
                    onSaved: (val) => authProv.enteredLastName = val!,
                  ),
                  _buildTextField(
                    'Kata Sandi',
                    Icons.lock_outline,
                    isPassword: true,
                    onSaved: (val) => authProv.enteredPassword = val!,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah memiliki akun? ',
                          style: TextStyle(fontSize: 13)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const WSignIn()),
                          );
                        },
                        child: const Text(
                          'Masuk di sini',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () async {
                      authProv.islogin = false;
                      final errorMessage = await authProv.submit();
                      if (!context.mounted) return;
                      if (errorMessage == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const W_Homepage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: Colors.red,
                          ),
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
                      child: const Center(
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}