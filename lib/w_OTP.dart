import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'auth_provider.dart';
import 'w_input_name.dart';
import 'w_homepage.dart'; // Tambahkan import Homepage untuk jalur Login

class WOtp extends StatefulWidget {
  final String phoneNumber;
  final bool isLogin; // Variabel baru untuk mendeteksi mode

  const WOtp({super.key, required this.phoneNumber, this.isLogin = false});

  @override
  State<WOtp> createState() => _WOtpState();
}

class _WOtpState extends State<WOtp> {
  Timer? _timer;
  int _start = 59;

  // Siapkan 6 Controller dan FocusNode
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
      height: 55, // Diperkecil agar muat 6 kotak sejajar
      decoration: BoxDecoration(
        color: const Color(0xFFB0E6F3).withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFB0E6F3)),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF004D56),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Judul menyesuaikan, kalau lagi login tulis "Masuk", kalau daftar tulis "Daftar"
              Text(
                widget.isLogin ? 'Masuk' : 'Daftar',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D56),
                ),
              ),
              const SizedBox(height: 40),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Masukkan Kode Verifikasi\nKami telah mengirimkan kode 6 digit ke nomor ${widget.phoneNumber}',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),

              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tidak menerima kode?',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _start == 0
                          ? () {
                              setState(() {
                                _start = 59;
                                startTimer();
                              });
                              // Bisa panggil ulang fungsi sendPhoneOTP di sini nanti
                            }
                          : null,
                      child: Text(
                        _start == 0
                            ? 'Kirim ulang kode sekarang'
                            : 'Kirim ulang kode (00:${_start.toString().padLeft(2, '0')})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _start == 0
                              ? const Color(0xFF004E62)
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),

              GestureDetector(
                onTap: () async {
                  String finalOtp = _otpControllers.map((c) => c.text).join();

                  if (finalOtp.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Masukkan 6 digit OTP!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Verifikasi ke Firebase dengan membawa param isLogin
                  final error = await authProv.verifyOTP(
                    finalOtp,
                    widget.isLogin,
                  );

                  if (!context.mounted) return;

                  if (error == null) {
                    // --- INI LOGIKA BARUNYA ---
                    if (widget.isLogin) {
                      // Jika sedang LOGIN, hapus halaman sebelumnya dan langsung ke Beranda
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const W_Homepage(),
                        ),
                        (route) => false,
                      );
                    } else {
                      // Jika sedang DAFTAR, lanjut ke halaman isi nama
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
                        content: Text(error),
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
    );
  }
}
