import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Tambahan wajib untuk mendeteksi Web (kIsWeb)

final _fireAuth = FirebaseAuth.instance;

class AuthProvider extends ChangeNotifier {
  final form = GlobalKey<FormState>();

  var islogin = true;
  var enteredEmail = '';
  var enteredPassword = '';
  var enteredFirstName = '';
  var enteredLastName = '';

  // === TAMBAHAN UNTUK FITUR OTP ===
  String verificationId = '';
  ConfirmationResult?
  webConfirmationResult; // Tambahan khusus untuk menyimpan OTP di Web

  // 1. Fungsi Mengirim OTP (Sudah mendukung Web dan Mobile)
  Future<void> sendPhoneOTP({
    required String phone,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    // Ubah 0812... menjadi +62812... (Format standar Firebase)
    String formattedPhone = phone;
    if (phone.startsWith('0')) {
      formattedPhone = '+62${phone.substring(1)}';
    }

    try {
      if (kIsWeb) {
        // --- LOGIKA KHUSUS FLUTTER WEB ---
        // Di web, kita menggunakan signInWithPhoneNumber (Otomatis memanggil reCAPTCHA)
        webConfirmationResult = await _fireAuth.signInWithPhoneNumber(
          formattedPhone,
        );
        onSuccess();
      } else {
        // --- LOGIKA KHUSUS ANDROID & IOS ---
        await _fireAuth.verifyPhoneNumber(
          phoneNumber: formattedPhone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            try {
              await _fireAuth.signInWithCredential(credential);
            } catch (e) {
              debugPrint("Auto-login gagal: $e");
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            onError(e.message ?? 'Gagal mengirim OTP. Pastikan nomor valid.');
          },
          codeSent: (String verId, int? resendToken) {
            verificationId = verId; // Simpan ID ini untuk dicocokkan nanti
            onSuccess(); // Pindah ke halaman OTP
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? 'Terjadi kesalahan sistem (${e.code})');
    } catch (e) {
      onError('Error: $e'); // Menangkap error lain jika ada
    }
  }

  // 2. Fungsi Mengecek OTP (Mendeteksi Pengguna Baru/Lama + Mendukung Web)
  Future<String?> verifyOTP(String otp, bool isLoginFlow) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // --- VERIFIKASI KHUSUS WEB ---
        if (webConfirmationResult == null) return "Sesi OTP tidak ditemukan.";
        userCredential = await webConfirmationResult!.confirm(otp);
      } else {
        // --- VERIFIKASI KHUSUS ANDROID/IOS ---
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        );
        userCredential = await _fireAuth.signInWithCredential(credential);
      }

      // Cek apakah ini akun baru yang terbuat otomatis
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      // Logika Pengecekan Masuk vs Daftar
      if (isLoginFlow && isNewUser) {
        // Jika niatnya Masuk, tapi ternyata belum terdaftar
        await userCredential.user?.delete(); // Hapus akun sementara
        await _fireAuth.signOut();
        return 'Nomor belum terdaftar. Silakan daftar terlebih dahulu.';
      }

      if (!isLoginFlow && !isNewUser) {
        // Jika niatnya Daftar, tapi ternyata sudah pernah terdaftar
        await _fireAuth.signOut();
        return 'Nomor ini sudah terdaftar. Silakan langsung masuk.';
      }

      return null; // Lolos verifikasi!
    } on FirebaseAuthException catch (_) {
      return 'Kode OTP salah atau sudah kedaluwarsa.';
    } catch (e) {
      return "Terjadi kesalahan sistem: $e";
    }
  }

  // 3. Fungsi Menyimpan Nama setelah OTP berhasil
  Future<String?> updateNameAndFinish(String firstName, String lastName) async {
    try {
      final user = _fireAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName('$firstName $lastName');
        return null; // Sukses
      }
      return 'Pengguna tidak ditemukan.';
    } catch (e) {
      return e.toString();
    }
  }
  // ================================

  // Fungsi Submit untuk Email (Tetap sama seperti sebelumnya)
  Future<String?> submit() async {
    final isValid = form.currentState!.validate();
    if (!isValid) return "Silakan lengkapi form dengan benar.";
    form.currentState!.save();

    try {
      if (islogin) {
        await _fireAuth.signInWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
        return null;
      } else {
        final userCredential = await _fireAuth.createUserWithEmailAndPassword(
          email: enteredEmail,
          password: enteredPassword,
        );
        await userCredential.user!.updateDisplayName(
          '$enteredFirstName $enteredLastName',
        );
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        return 'Email atau kata sandi salah.';
      } else if (e.code == 'email-already-in-use') {
        return 'Email ini sudah terdaftar. Silakan gunakan email lain atau masuk.';
      } else if (e.code == 'weak-password') {
        return 'Kata sandi terlalu lemah (minimal 6 karakter).';
      } else if (e.code == 'invalid-email') {
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
