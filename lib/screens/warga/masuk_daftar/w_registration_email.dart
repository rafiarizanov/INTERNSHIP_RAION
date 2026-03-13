import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import 'w_registration_phone.dart';
import 'w_sign_in.dart';
import 'w_verifikasi_email.dart';

class WRegistrationEmail extends StatefulWidget {
  const WRegistrationEmail({super.key});

  @override
  State<WRegistrationEmail> createState() => _WRegistrationEmailState();
}

class _WRegistrationEmailState extends State<WRegistrationEmail> {
  bool _obscurePassword = true;
  bool _isLoading = false;
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
        obscureText: isPassword ? _obscurePassword : false,
        onSaved: onSaved,
        style: AppTextStyles.bodyMid,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.title1.copyWith(color: Colors.grey),
          prefixIcon: Icon(icon, color: AppColors.primaryPetugas),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.primaryPetugas,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
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
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Form(
                key: authProv.form,
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
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const WRegistrationPhone(),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.blueLightActive,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Gunakan No. Telp',
                                  style: AppTextStyles.title1Bold.copyWith(
                                    color: AppColors.primaryPetugas,
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
                              color: AppColors.primaryPetugas,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Gunakan Email',
                                style: AppTextStyles.title1Bold.copyWith(
                                  color: Colors.white,
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

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah memiliki akun? ',
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
                            'Masuk di sini',
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
                      onTap: () async {
                        setState(() => _isLoading = true);
                        authProv.islogin = false;
                        final errorMessage = await authProv.submit();
                        if (!context.mounted) return;
                        setState(() => _isLoading = false);

                        if (errorMessage == null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WVerificationEmail(
                                email: authProv.enteredEmail,
                              ),
                            ),
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
      ),
    );
  }
}
