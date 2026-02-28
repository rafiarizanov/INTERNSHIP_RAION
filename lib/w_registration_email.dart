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
  bool isHoverPhone = false;

  // Widget bantuan untuk input field yang terintegrasi dengan Form
  Widget _buildTextField(
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
            onSaved:
                onSaved, // Mengirim data ke Provider saat form.save() dipanggil
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
    // Memanggil AuthProvider (listen: false karena hanya dipakai saat tombol ditekan)
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            // 1. Membungkus seluruh input dengan Form
            key: authProv.form, // 2. Menghubungkan GlobalKey dari Provider
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D56),
                  ),
                ),
                const SizedBox(height: 30),

                // Tab Selektor (Nomor HP / Email)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      onEnter: (_) => setState(() => isHoverPhone = true),
                      onExit: (_) => setState(() => isHoverPhone = false),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WRegistrationPhone(),
                            ),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 130,
                          height: 45,
                          decoration: BoxDecoration(
                            color: isHoverPhone
                                ? const Color(0xFF004E62)
                                : const Color(0xFFB0E6F3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              'Nomor HP',
                              style: TextStyle(
                                color: isHoverPhone
                                    ? Colors.white
                                    : const Color(0xFF004D56),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 130,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFF004E62),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Area Input Field yang terhubung ke Provider
                _buildTextField(
                  'Email',
                  onSaved: (val) => authProv.enteredEmail = val!,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  'Nama depan',
                  onSaved: (val) => authProv.enteredFirstName = val!,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  'Nama belakang',
                  onSaved: (val) => authProv.enteredLastName = val!,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  'Kata sandi',
                  isPassword: true,
                  onSaved: (val) => authProv.enteredPassword = val!,
                ),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6, left: 8),
                    child: Text(
                      '*minimal 8 karakter',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Link Ke Halaman Masuk
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah memiliki akun? ',
                      style: TextStyle(fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WSignIn(),
                          ),
                        );
                      },
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D56),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const Text(' di sini', style: TextStyle(fontSize: 13)),
                  ],
                ),

                const SizedBox(height: 40),

                // Tombol Lanjut (Submit)
                GestureDetector(
                  onTap: () async {
                    // Set mode ke Register
                    authProv.islogin = false;

                    // Eksekusi fungsi submit dan tunggu hasilnya
                    final errorMessage = await authProv.submit();

                    // Pastikan widget masih ada di layar sebelum merender UI baru
                    if (!context.mounted) return;

                    if (errorMessage == null) {
                      // JIKA SUKSES
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pendaftaran Berhasil!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Pindah ke OTP
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const W_Homepage(),
                        ),
                      );
                    } else {
                      // JIKA GAGAL (Tampilkan pesan error)
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
