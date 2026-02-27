import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  
  void _handleRegister() {
    String email = _emailController.text.trim();
    String firstName = _firstNameController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || firstName.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom wajib diisi!')),
      );
    } else if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email salah! (Gunakan @)')),
      );
    } else if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 8 karakter!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun Berhasil Didaftar!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Daftar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),
              
              // Tombol Pilihan Nomor HP & Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120, height: 30,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(15)),
                    child: const Center(child: Text('Nomor HP', style: TextStyle(fontSize: 12))),
                  ), 
                  const SizedBox(width: 25),
                  Container(
                    width: 120, height: 30,
                    decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(15)),
                    child: const Center(child: Text('Email', style: TextStyle(color: Colors.white, fontSize: 12))),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // --- INPUT EMAIL ---
              const Align(alignment: Alignment.centerLeft, child: Text('Email', style: TextStyle(fontWeight: FontWeight.w500))),
              const SizedBox(height: 8),
              _customTextField(_emailController, false),

              const SizedBox(height: 15),

              // --- INPUT NAMA DEPAN ---
              const Align(alignment: Alignment.centerLeft, child: Text('Nama depan', style: TextStyle(fontWeight: FontWeight.w500))),
              const SizedBox(height: 8),
              _customTextField(_firstNameController, false),

              const SizedBox(height: 15),

              // --- INPUT NAMA BELAKANG ---
              const Align(alignment: Alignment.centerLeft, child: Text('Nama Belakang', style: TextStyle(fontWeight: FontWeight.w500))),
              const SizedBox(height: 8),
              _customTextField(_lastNameController, false),

              const SizedBox(height: 15),

              // --- INPUT KATA SANDI ---
              const Align(alignment: Alignment.centerLeft, child: Text('Kata sandi', style: TextStyle(fontWeight: FontWeight.w500))),
              const SizedBox(height: 8),
              _customTextField(_passwordController, true),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.centerLeft, 
                child: Text('*minimal 8 karakter', style: TextStyle(fontSize: 10, color: Colors.grey))
              ),

              const SizedBox(height: 25),
              Text.rich(
                TextSpan(
                  text: 'Sudah memiliki akun? ',
                  style: const TextStyle(fontSize: 11),
                  children: [
                    TextSpan(
                      text: 'Masuk',
                      style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              // --- TOMBOL LANJUT ---
              GestureDetector(
                onTap: _handleRegister,
                child: Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Text('Lanjut', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  Widget _customTextField(TextEditingController controller, bool isPassword) {
    return Container(
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300], 
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        textAlignVertical: TextAlignVertical.center, 
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          isDense: true, 
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
    );
  }
}