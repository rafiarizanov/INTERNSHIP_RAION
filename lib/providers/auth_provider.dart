import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

final _supabaseAuth = Supabase.instance.client.auth;

class AuthProvider extends ChangeNotifier {
  String _namaDaerah = '';
  String get namaDaerah => _namaDaerah;

  final Map<String, Map<String, String>> _dataPetugas = {
    '12345678': {'pass': 'petugas123', 'wilayah': 'Kabupaten Malang'},
    '87654321': {'pass': 'admin456', 'wilayah': 'Kota Surabaya'},
    '11223344': {'pass': 'petugas01', 'wilayah': 'DKI Jakarta'},
  };

  Future<String?> loginPetugas(String nip, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_dataPetugas.containsKey(nip)) {
      if (_dataPetugas[nip]!['pass'] == password) {
        _namaDaerah = _dataPetugas[nip]!['wilayah']!;
        notifyListeners();
        return null;
      } else {
        return 'Kata sandi salah. Silakan coba lagi.';
      }
    } else {
      return 'NIP tidak ditemukan. Pastikan Anda memasukkan NIP yang benar.';
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
      bool isNewUser = userMetadata['display_name'] == null || userMetadata['display_name'] == '';

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
          UserAttributes(
            data: {'display_name': '$firstName $lastName'},
          ),
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
      
      if (msg.contains('invalid login credentials') || msg.contains('invalid credentials')) {
        return 'Email atau kata sandi salah.';
      } else if (msg.contains('already registered') || msg.contains('user already exists')) {
        return 'Email ini sudah terdaftar. Silakan gunakan email lain atau masuk.';
      } else if (msg.contains('weak password') || msg.contains('password should be at least')) {
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
}