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

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ChoosingPage()),
                (route) => false,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF004D56),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    const Text(
                      'Masuk Sebagai Petugas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D56),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    const Text(
                      'Gunakan NIP Anda beserta kata sandi yang\ntelah diberikan untuk dapat masuk.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF004D56),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/image/Petugas Card.png',
                        height: screenHeight * 0.25,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported,
                          size: screenHeight * 0.06,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    _buildPetugasInput(
                      label: "NIP Anda",
                      icon: Icons.contact_mail_outlined,
                      controller: _nipController,
                      screenHeight: screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildPetugasInput(
                      label: "Kata Sandi",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                      screenHeight: screenHeight,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    GestureDetector(
                      onTap: _isLoading ? null : _handleLogin,
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: _isLoading ? Colors.grey : const Color(0xFF004D56),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
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
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildPetugasInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required double screenHeight,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF004D56)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
        ),
      ),
    );
  }
}