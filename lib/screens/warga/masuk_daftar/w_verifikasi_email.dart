import 'dart:async';
import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'w_registrasi_berhasil.dart';

class WVerificationEmail extends StatefulWidget {
  final String email;

  const WVerificationEmail({super.key, required this.email});

  @override
  State<WVerificationEmail> createState() => _WVerificationEmailState();
}

class _WVerificationEmailState extends State<WVerificationEmail> {
  int _start = 59;
  Timer? _timer;
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    startTimer();

    
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WRegistrasiBerhasil()),
        );
      }
    });
  }

  void startTimer() {
    _start = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _start--);
      }
    });
  }

  Future<void> resendEmail() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final error = await authProv.resendEmailVerification(widget.email);

    if (error == null) {
      startTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tautan verifikasi telah dikirim ulang'), backgroundColor: Colors.green),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim ulang: $error'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryPetugas,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryPetugas,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.blueLightActive,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 10),
            child: Text('1/2', style: AppTextStyles.title1Bold.copyWith(color: AppColors.primaryPetugas)),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(Icons.water_drop, size: 120, color: Colors.cyan[400]), 
              const SizedBox(height: 30),
              Text(
                'Verifikasi Email Anda',
                style: AppTextStyles.h3Bold.copyWith(fontSize: 22, color: AppColors.primaryPetugas),
              ),
              const SizedBox(height: 15),
              Text(
                'Kami telah mengirimkan tautan verifikasi kepada\n${widget.email}. Klik tautan tersebut untuk\nmelanjutkan ke aplikasi.',
                textAlign: TextAlign.center,
                style: AppTextStyles.title1.copyWith(color: AppColors.primaryPetugas, height: 1.4),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Belum menerima tautan? ', style: AppTextStyles.title1.copyWith(fontSize: 13, color: AppColors.primaryPetugas)),
                  GestureDetector(
                    onTap: _start == 0 ? resendEmail : null,
                    child: Text(
                      'Kirim ulang',
                      style: AppTextStyles.title1Bold.copyWith(
                        fontSize: 13,
                        color: _start == 0 ? AppColors.primaryPetugas : Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    _start > 0 ? ' dalam 00:${_start.toString().padLeft(2, '0')}' : '',
                    style: AppTextStyles.title1.copyWith(fontSize: 13, color: AppColors.primaryPetugas),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silakan buka aplikasi email Anda.')),
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
                    child: Text(
                      'Buka Email',
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