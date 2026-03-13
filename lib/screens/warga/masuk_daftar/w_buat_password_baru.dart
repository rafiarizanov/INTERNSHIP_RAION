import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'w_sign_in.dart';

class WBuatPasswordBaru extends StatefulWidget {
  const WBuatPasswordBaru({super.key});

  @override
  State<WBuatPasswordBaru> createState() => _WBuatPasswordBaruState();
}

class _WBuatPasswordBaruState extends State<WBuatPasswordBaru> {
  bool _obscureSandi1 = true;
  bool _obscureSandi2 = true;
  bool _isLoading = false;

  final TextEditingController _pass1Controller = TextEditingController();
  final TextEditingController _pass2Controller = TextEditingController();

  Widget _buildPassField(String hint, TextEditingController controller, bool isObscured, VoidCallback toggle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFF709096))),
      child: TextField(
        controller: controller, obscureText: isObscured, style: AppTextStyles.bodyMid,
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryPetugas), suffixIcon: IconButton(icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility, color: AppColors.primaryPetugas), onPressed: toggle), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Icon(Icons.password_rounded, size: 100, color: AppColors.primaryPetugas),
              const SizedBox(height: 20),
              Text('Buat Kata Sandi Baru', style: AppTextStyles.h2Bold.copyWith(color: AppColors.primaryPetugas)),
              const SizedBox(height: 10),
              Text('Sandi baru Anda harus unik dan berbeda\ndari kata sandi yang digunakan sebelumnya.', textAlign: TextAlign.center, style: AppTextStyles.title1.copyWith(color: AppColors.primaryPetugas, height: 1.4)),
              const SizedBox(height: 40),
              
              _buildPassField('Kata Sandi Baru', _pass1Controller, _obscureSandi1, () => setState(() => _obscureSandi1 = !_obscureSandi1)),
              _buildPassField('Konfirmasi Kata Sandi', _pass2Controller, _obscureSandi2, () => setState(() => _obscureSandi2 = !_obscureSandi2)),
              
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _isLoading ? null : () async {
                  if (_pass1Controller.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kata sandi minimal 6 karakter.'), backgroundColor: Colors.red)); return;
                  }
                  if (_pass1Controller.text != _pass2Controller.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kata sandi tidak cocok!'), backgroundColor: Colors.red)); return;
                  }

                  setState(() => _isLoading = true);
                  final error = await authProv.updateNewPassword(_pass1Controller.text);
                  if (!context.mounted) return;
                  setState(() => _isLoading = false);

                  if (error == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil! Silakan masuk dengan sandi baru.'), backgroundColor: Colors.green));
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WSignIn()), (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $error'), backgroundColor: Colors.red));
                  }
                },
                child: Container(width: double.infinity, height: 55, decoration: BoxDecoration(color: _isLoading ? Colors.grey : AppColors.primaryPetugas, borderRadius: BorderRadius.circular(15)), child: Center(child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text('Simpan & Masuk', style: AppTextStyles.title2Bold.copyWith(color: Colors.white)))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}