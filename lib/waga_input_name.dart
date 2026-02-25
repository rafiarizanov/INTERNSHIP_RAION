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
              
              const SizedBox(height: 100),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Nama depan', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 8),

              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Nama Belakang', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
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