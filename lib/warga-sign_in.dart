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
final TextEditingController _passwordController = TextEditingController();

void _handleLogin(){
  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  if (email.isEmpty || password.isEmpty){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email dan Password Harus Diisi ! '))
    );
  }
  else if (password.length<8){
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password minimal 8 karakter '))
    );
  }
  else{
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berhasil Login !  '))
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Masuk',
                style: TextStyle(fontSize: 20),
              ),
              
              const SizedBox(height: 55),

             
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Email atau Nomor telepon',style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
            child: TextField( 
              controller: _emailController,
              decoration: const InputDecoration( 
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
            )
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Kata sandi', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _passwordController, 
                  obscureText: true, 
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Ingat saya', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const Text(
                    'Lupa kata sandi?',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 85),
              GestureDetector(
                onTap: _handleLogin, 
                child: Container(
                  width: 290,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text('Masuk',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Text.rich(TextSpan(
                  text: 'Belum Punya akun? ',
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Daftar',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    )
                  ])),
            ], 
          ), 
        ), 
      ), 
    ); 
  }
}