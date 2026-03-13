
import 'package:INTERNSHIP_RAION/screens/umum/onboarding_page_1.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_homepage.dart';
import 'package:INTERNSHIP_RAION/screens/petugas/fitur/p_homepage.dart';
import 'package:INTERNSHIP_RAION/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoading = true;
  bool _isPetugasLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkPetugasSession();
  }

  Future<void> _checkPetugasSession() async {
    final prefs = await SharedPreferences.getInstance();
    final nip = prefs.getString('petugas_nip');

    if (nip != null) {
      if (mounted) {
        final authProv = Provider.of<AuthProvider>(context, listen: false);
        authProv.restorePetugasSession(
          nama: prefs.getString('petugas_nama') ?? 'Petugas DLH',
          wilayah: prefs.getString('petugas_wilayah') ?? 'Semua Daerah',
        );
        setState(() {
          _isPetugasLoggedIn = true;
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF004D56)),
        ),
      );
    }

    if (_isPetugasLoggedIn) {
      return const P_Homepage();
    }

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
          return const OnboardingPage1();
        }
      },
    );
  }
}
