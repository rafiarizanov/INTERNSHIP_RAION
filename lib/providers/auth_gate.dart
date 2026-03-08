import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// TODO: Pastikan path import ini sesuai dengan letak file Anda
import 'package:INTERNSHIP_RAION/screens/warga/masuk_daftar/w_sign_in.dart'; 
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_homepage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
  
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
     
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF004D56)),
            ),
          );
        }

        final session = snapshot.data?.session;

        if (session != null) {
          
          return const W_Homepage();
        } else {
          
          return const WSignIn();
        }
      },
    );
  }
}