import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

final _supabaseAuth = Supabase.instance.client.auth;

class AuthProvider extends ChangeNotifier {
 
  String _namaDaerah = '';
  String get namaDaerah => _namaDaerah;

  String _namaPetugas = '';
  String get namaPetugas => _namaPetugas;

  void restorePetugasSession({required String nama, required String wilayah}) {
    _namaPetugas = nama;
    _namaDaerah = wilayah;
    notifyListeners();
  }

  Future<String?> loginPetugas(String nip, String password) async {
    try {
      final response = await Supabase.instance.client
          .from('petugas')
          .select()
          .eq('nip', nip)
          .maybeSingle();

      if (response == null) {
        return 'NIP tidak ditemukan. Pastikan Anda memasukkan NIP yang benar.';
      }

      if (response['password'] == password) {
        _namaDaerah = response['wilayah'] ?? 'Semua Daerah';
        _namaPetugas = response['nama'] ?? 'Petugas DLH';

   
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('petugas_nip', nip);
        await prefs.setString('petugas_nama', _namaPetugas);
        await prefs.setString('petugas_wilayah', _namaDaerah);

        notifyListeners();
        return null;
      } else {
        return 'Kata sandi salah. Silakan coba lagi.';
      }
    } catch (e) {
      return 'Terjadi kesalahan sistem: $e';
    }
  }

  final form = GlobalKey<FormState>();
  var islogin = true;
  var enteredEmail = '';
  var enteredPassword = '';
  var enteredFirstName = '';
  var enteredLastName = '';
  var enteredPhone = '';

  Future<void> sendPhoneOTP({
    required String phone,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    String formattedPhone = phone;
    if (phone.startsWith('0')) {
      formattedPhone = '+62${phone.substring(1)}';
    }
    enteredPhone = formattedPhone;

    try {
      await _supabaseAuth.signInWithOtp(phone: formattedPhone);
      onSuccess();
    } on AuthException catch (e) {
      onError(e.message);
    } catch (e) {
      onError('Error: $e');
    }
  }

  Future<String?> verifyOTP(String otp, bool isLoginFlow) async {
    try {
      final AuthResponse res = await _supabaseAuth.verifyOTP(
        phone: enteredPhone,
        token: otp,
        type: OtpType.sms,
      );

      final user = res.user;
      if (user == null) return "Sesi OTP tidak ditemukan.";

      final userMetadata = user.userMetadata ?? {};
      bool isNewUser =
          userMetadata['display_name'] == null ||
          userMetadata['display_name'] == '';

      if (isLoginFlow && isNewUser) {
        await _supabaseAuth.signOut();
        return 'Nomor belum terdaftar. Silakan daftar terlebih dahulu.';
      }

      if (!isLoginFlow && !isNewUser) {
        await _supabaseAuth.signOut();
        return 'Nomor ini sudah terdaftar. Silakan langsung masuk.';
      }

      return null;
    } on AuthException catch (_) {
      return 'Kode OTP salah atau sudah kedaluwarsa.';
    } catch (e) {
      return "Terjadi kesalahan sistem: $e";
    }
  }

  Future<String?> updateNameAndFinish(String firstName, String lastName) async {
    try {
      final user = _supabaseAuth.currentUser;
      if (user != null) {
        await _supabaseAuth.updateUser(
          UserAttributes(data: {'display_name': '$firstName $lastName'}),
        );
        return null;
      }
      return 'Pengguna tidak ditemukan.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> submit() async {
    final isValid = form.currentState!.validate();
    if (!isValid) return "Silakan lengkapi form dengan benar.";
    form.currentState!.save();

    try {
      if (islogin) {
        await _supabaseAuth.signInWithPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
        return null;
      } else {
        await _supabaseAuth.signUp(
          email: enteredEmail,
          password: enteredPassword,
          emailRedirectTo: 'sadarair://login-callback',
          data: {'display_name': '$enteredFirstName $enteredLastName'},
        );
        return null;
      }
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();

      if (msg.contains('invalid login credentials') ||
          msg.contains('invalid credentials')) {
        return 'Email atau kata sandi salah.';
      } else if (msg.contains('already registered') ||
          msg.contains('user already exists')) {
        return 'Email ini sudah terdaftar. Silakan gunakan email lain atau masuk.';
      } else if (msg.contains('weak password') ||
          msg.contains('password should be at least')) {
        return 'Kata sandi terlalu lemah (minimal 6 karakter).';
      } else if (msg.contains('invalid email')) {
        return 'Format email tidak valid.';
      }
      return e.message;
    } catch (e) {
      return "Terjadi kesalahan sistem: $e";
    } finally {
      notifyListeners();
    }
  }


  Future<void> logoutPetugas() async {
    _namaDaerah = '';
    _namaPetugas = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('petugas_nip');
    await prefs.remove('petugas_nama');
    await prefs.remove('petugas_wilayah');

    notifyListeners();
  }

  Future<String?> resendEmailVerification(String email) async {
    try {
      await _supabaseAuth.resend(
        type: OtpType.signup,
        email: email,
      );
      return null; 
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _supabaseAuth.resetPasswordForEmail(email);
      return null; 
    } catch (e) {
      return e.toString(); 
    }
  }
  
  Future<String?> verifyPasswordResetOTP(String email, String otp) async {
    try {
      await _supabaseAuth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.recovery, // Ini penanda bahwa OTP ini khusus untuk lupa password
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 🌟 [BARU] FUNGSI UNTUK MENYIMPAN SANDI BARU
  Future<String?> updateNewPassword(String newPassword) async {
    try {
      await _supabaseAuth.updateUser(UserAttributes(password: newPassword));
      return null;
    } catch (e) {
      return e.toString();
    }
  }

}
