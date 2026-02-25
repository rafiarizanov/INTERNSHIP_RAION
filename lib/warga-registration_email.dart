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
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(child: Text('Nomor HP')),
                  ), 
                  const SizedBox(width: 25),
                  Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text('Email', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

             
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Email', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
              ), 

              const SizedBox(height: 15),

              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Nama depan', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              const SizedBox(height: 15),

              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Nama Belakang', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              const SizedBox(height: 15),

             
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Kata sandi', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              
                const SizedBox(height:10),
                 const Align(
                alignment: Alignment.centerLeft,
                child: Text('*minimal 8 karakter', style: TextStyle(fontSize: 9)),
              ),

              const SizedBox(height: 25),
              Text.rich(
                TextSpan( 
                  text: 'Sudah memiliki akun?  ',
                  style: const TextStyle(fontSize: 10,color: Colors.black),
                  children: [ 
                    TextSpan( 
                      text: 'Masuk',
                      style: const TextStyle( fontSize: 10, 
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      ),

                    )
                  ]
                )
              ),

              

              const SizedBox(height: 100),

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