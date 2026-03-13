import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../umum/choosing.dart';
import '../fitur/p_homepage.dart';

class PSignIn extends StatefulWidget {
  const PSignIn({super.key});

  @override
  State<PSignIn> createState() => _PSignInState();
}

class _PSignInState extends State<PSignIn> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProv.loginPetugas(nip, password);

    setState(() {
      _isLoading = false;
    });

    if (error == null) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const P_Homepage()),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildPetugasInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        style: AppTextStyles.bodyMid,
        decoration: InputDecoration(
          hintText: label,
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
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChoosingPage(),
                              ),
                              (route) => false,
                            );
                          },
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
                    const SizedBox(height: 20),
                    Text(
                      'Masuk Sebagai Petugas',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.h3Bold.copyWith(
                        fontSize: 22,
                        color: AppColors.primaryPetugas,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gunakan NIP Anda beserta kata sandi yang\ntelah diberikan untuk dapat masuk.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title1.copyWith(
                        fontSize: 13,
                        color: AppColors.primaryPetugas,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/image/Petugas Card.png',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildPetugasInput(
                      label: "NIP Anda",
                      icon: Icons.contact_mail_outlined,
                      controller: _nipController,
                    ),
                    _buildPetugasInput(
                      label: "Kata Sandi",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                    ),

                    const Spacer(),

                    GestureDetector(
                      onTap: _isLoading ? null : _handleLogin,
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: _isLoading
                              ? Colors.grey
                              : AppColors.primaryPetugas,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Masuk',
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
