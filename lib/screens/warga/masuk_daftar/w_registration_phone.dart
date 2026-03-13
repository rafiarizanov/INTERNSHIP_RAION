import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/screens/warga/masuk_daftar/w_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'w_registration_email.dart';
import 'w_OTP.dart';

class WRegistrationPhone extends StatefulWidget {
  const WRegistrationPhone({super.key});

  @override
  State<WRegistrationPhone> createState() => _WRegistrationPhoneState();
}

class _WRegistrationPhoneState extends State<WRegistrationPhone> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            color: AppColors.primaryPetugas,
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
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/image/logo.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'Daftar Sebagai Warga',
                    style: AppTextStyles.h3Bold.copyWith(
                      fontSize: 22,
                      color: AppColors.primaryPetugas,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primaryPetugas,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              'Gunakan No. Telp',
                              style: AppTextStyles.title1Bold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WRegistrationEmail(),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.blueLightActive,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Gunakan Email',
                                style: AppTextStyles.title1Bold.copyWith(
                                  color: AppColors.primaryPetugas,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF709096)),
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.bodyMid,
                      decoration: InputDecoration(
                        hintText: 'Nomor Telepon',
                        hintStyle: AppTextStyles.title1.copyWith(
                          color: Colors.grey,
                        ),
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: AppColors.primaryPetugas,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sudah memiliki akun? ",
                        style: AppTextStyles.title1.copyWith(fontSize: 13),
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
                        child: Text(
                          "Masuk di sini",
                          style: AppTextStyles.title1Bold.copyWith(
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      if (_phoneController.text.isEmpty) return;
                      setState(() => _isLoading = true);
                      authProv.sendPhoneOTP(
                        phone: _phoneController.text.trim(),
                        onSuccess: () {
                          setState(() => _isLoading = false);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WOtp(phoneNumber: _phoneController.text),
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
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPetugas,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Daftar',
                                style: AppTextStyles.title2Bold.copyWith(
                                  color: Colors.white,
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
