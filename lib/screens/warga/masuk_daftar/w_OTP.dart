import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../providers/auth_provider.dart';
import 'w_input_name.dart';
import '../fitur/w_homepage.dart';

class WOtp extends StatefulWidget {
  final String phoneNumber;
  final bool isLogin;

  const WOtp({super.key, required this.phoneNumber, this.isLogin = false});

  @override
  State<WOtp> createState() => _WOtpState();
}

class _WOtpState extends State<WOtp> {
  Timer? _timer;
  int _start = 59;
  bool _isLoading = false; 

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF709096)),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.h2Bold.copyWith(
          fontSize: 22,
          color: AppColors.primaryPetugas,
        ),
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
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
                    'Masukkan Kode Verifikasi',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h3Bold.copyWith(
                      fontSize: 22,
                      color: AppColors.primaryPetugas,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kode verifikasi 6 digit telah dikirim ke\n${widget.phoneNumber}. Silakan cek SMS Anda.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.title1.copyWith(
                      fontSize: 13,
                      color: AppColors.primaryPetugas,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) => _buildOtpBox(index)),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum menerima kode? ',
                        style: AppTextStyles.title1.copyWith(
                          fontSize: 13,
                          color: AppColors.primaryPetugas,
                        ),
                      ),
                      GestureDetector(
                        onTap: _start == 0
                            ? () {
                                setState(() {
                                  _start = 59;
                                  startTimer();
                                });
                              }
                            : null,
                        child: Text(
                          _start == 0
                              ? 'Kirim ulang'
                              : 'Kirim ulang dalam 00:${_start.toString().padLeft(2, '0')}',
                          style: AppTextStyles.title1Bold.copyWith(
                            fontSize: 13,
                            color: AppColors.primaryPetugas,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () async {
                            String finalOtp = _otpControllers
                                .map((c) => c.text)
                                .join();

                            if (finalOtp.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Harap masukkan 6 digit kode OTP secara lengkap.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() => _isLoading = true);

                            final error = await authProv.verifyOTP(
                              finalOtp,
                              widget.isLogin,
                            );

                            if (!context.mounted) return;

                            setState(() => _isLoading = false);

                            if (error == null) {
                              if (widget.isLogin) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const W_Homepage(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WInputName(),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal verifikasi: $error'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
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
                                'Lanjut',
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
