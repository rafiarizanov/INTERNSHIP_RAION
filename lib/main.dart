import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Tambahkan ini
import 'firebase_options.dart'; // Tambahkan ini agar kenal konfigurasi kamu
import 'splash_screen.dart';

void main() async {
  // Tambahkan 'async' di sini
  // Baris ini wajib ada agar plugin bisa berjalan sebelum aplikasi muncul
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase berdasarkan pengaturan dari CLI tadi
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'bersih.in',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
