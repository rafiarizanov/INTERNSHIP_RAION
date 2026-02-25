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
  Widget _buildOTPBox() {
    return Container(
      width: 55,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
    );
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
                'Daftar',
                style: TextStyle(fontSize: 20),
              ),
               const SizedBox(height:10),
                 const Align(
                alignment: Alignment.centerLeft,
                child: Text('Masukkan Kode Verifikasi Kami telah mengirimkan kode 6 digit ke nomor 08xxxxx',
               style: TextStyle(fontSize: 9)),
              ),

              const SizedBox(height: 30), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                children: [
                  _buildOTPBox(),
                  _buildOTPBox(),
                  _buildOTPBox(),
                  _buildOTPBox(),
                ],
              ),
            const SizedBox(height:10),
                 const Align(
                alignment: Alignment.centerLeft,
                child: Text('Tidak menerima kode?',
               style: TextStyle(fontSize: 9)),
              ),
               const Align(
                alignment: Alignment.centerLeft,
                child: Text('Kirim ulang kode (00:59)',
               style: TextStyle(fontSize: 9)),
              ),

              const SizedBox(height: 400),

              Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('Lanjut', style: TextStyle(fontSize: 16)),
                ),
              ), 

            ], 
          ), 
        ), 
      ), 
    ); 
  }
}