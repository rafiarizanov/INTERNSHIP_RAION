import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

class WLupaPassword extends StatefulWidget {
  const WLupaPassword({super.key});

  @override
  State<WLupaPassword> createState() => _WLupaPasswordState();
}

class _WLupaPasswordState extends State<WLupaPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleResetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap masukkan alamat email Anda.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProv.sendPasswordResetEmail(email);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tautan pemulihan telah dikirim ke email Anda.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Kembali ke halaman login setelah sukses
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $error'), backgroundColor: Colors.red),
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
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryPetugas,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Icon(Icons.lock_reset, size: 100, color: AppColors.primaryPetugas),
              const SizedBox(height: 20),
              Text(
                'Lupa Kata Sandi?',
                style: AppTextStyles.h2Bold.copyWith(color: AppColors.primaryPetugas),
              ),
              const SizedBox(height: 10),
              Text(
                'Masukkan email yang terdaftar. Kami akan mengirimkan tautan untuk mengatur ulang kata sandi Anda.',
                textAlign: TextAlign.center,
                style: AppTextStyles.title1.copyWith(color: AppColors.primaryPetugas, height: 1.4),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF709096)),
                ),
                child: TextField(
                  controller: _emailController,
                  style: AppTextStyles.bodyMid,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Alamat Email',
                    hintStyle: AppTextStyles.title1.copyWith(color: Colors.grey),
                    prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryPetugas),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _isLoading ? null : _handleResetPassword,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.grey : AppColors.primaryPetugas,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Kirim Tautan',
                            style: AppTextStyles.title2Bold.copyWith(color: Colors.white),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}