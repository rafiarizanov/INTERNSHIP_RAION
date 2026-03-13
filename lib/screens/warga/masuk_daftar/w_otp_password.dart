import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'w_buat_password_baru.dart';

class WOtpPassword extends StatefulWidget {
  final String email;
  const WOtpPassword({super.key, required this.email});

  @override
  State<WOtpPassword> createState() => _WOtpPasswordState();
}

class _WOtpPasswordState extends State<WOtpPassword> {
  bool _isLoading = false;
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  Widget _buildOtpBox(int index) {
    return Container(
      width: 45, height: 55,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF709096))),
      child: TextField(
        controller: _otpControllers[index], focusNode: _focusNodes[index],
        textAlign: TextAlign.center, keyboardType: TextInputType.number, maxLength: 1,
        style: AppTextStyles.h2Bold.copyWith(fontSize: 22, color: AppColors.primaryPetugas),
        decoration: const InputDecoration(counterText: "", border: InputBorder.none),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) _focusNodes[index + 1].requestFocus();
          else if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: Padding(padding: const EdgeInsets.all(8.0), child: GestureDetector(onTap: () => Navigator.pop(context), child: Container(decoration: BoxDecoration(color: AppColors.primaryPetugas, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18))))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Icon(Icons.mark_email_read_outlined, size: 100, color: AppColors.primaryPetugas),
              const SizedBox(height: 20),
              Text('Verifikasi Email', style: AppTextStyles.h2Bold.copyWith(color: AppColors.primaryPetugas)),
              const SizedBox(height: 10),
              Text('Masukkan 6 digit kode yang telah dikirim ke\n${widget.email}', textAlign: TextAlign.center, style: AppTextStyles.title1.copyWith(color: AppColors.primaryPetugas, height: 1.4)),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(6, (index) => _buildOtpBox(index))),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: _isLoading ? null : () async {
                  String finalOtp = _otpControllers.map((c) => c.text).join();
                  if (finalOtp.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap lengkapi kode OTP.'), backgroundColor: Colors.red));
                    return;
                  }
                  setState(() => _isLoading = true);
                  final error = await authProv.verifyPasswordResetOTP(widget.email, finalOtp);
                  if (!context.mounted) return;
                  setState(() => _isLoading = false);

                  if (error == null) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WBuatPasswordBaru()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kode OTP salah / kedaluwarsa.'), backgroundColor: Colors.red));
                  }
                },
                child: Container(width: double.infinity, height: 55, decoration: BoxDecoration(color: _isLoading ? Colors.grey : AppColors.primaryPetugas, borderRadius: BorderRadius.circular(15)), child: Center(child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text('Verifikasi', style: AppTextStyles.title2Bold.copyWith(color: Colors.white)))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}