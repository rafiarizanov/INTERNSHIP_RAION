import 'package:flutter/material.dart';
import 'dart:async';
import 'w_input_name.dart';

class WOtp extends StatefulWidget {
  const WOtp({super.key});

  @override
  State<WOtp> createState() => _WOtpState();
}

class _WOtpState extends State<WOtp> {
  // Variabel untuk hitung mundur
  Timer? _timer;
  int _start = 59; // Mulai dari 59 detik

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // Fungsi untuk menjalankan hitung mundur
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Jangan lupa mematikan timer saat pindah halaman
    super.dispose();
  }

  // Widget untuk kotak input OTP
  Widget _buildOtpBox() {
    return Container(
      width: 60,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, // Hanya satu angka per kotak
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "", // Menghilangkan indikator jumlah karakter
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Daftar',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              const Text(
                'Masukkan Kode Verifikasi\nKami telah mengirimkan kode 6 digit ke nomor 08xxxxx',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 30),

              // Barisan kotak OTP (disesuaikan dengan gambar ada 4 kotak)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOtpBox(),
                  _buildOtpBox(),
                  _buildOtpBox(),
                  _buildOtpBox(),
                ],
              ),
              const SizedBox(height: 30),

              // Bagian Timer dan Kirim Ulang
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tidak menerima kode?',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: _start == 0 ? () {
                        setState(() {
                          _start = 59;
                          startTimer();
                        });
                      } : null,
                      child: Text(
                        _start == 0 
                          ? 'Kirim ulang kode sekarang' 
                          : 'Kirim ulang kode (00:${_start.toString().padLeft(2, '0')})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _start == 0 ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 150),

              // Tombol Lanjut
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WInputName()),
                  );
                  print("OTP Terverifikasi");
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Lanjut',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}