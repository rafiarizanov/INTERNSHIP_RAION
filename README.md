# SadarAir - Mobile Application

Aplikasi SadarAir dikembangkan menggunakan Flutter dengan integrasi Supabase sebagai solusi manajemen air digital.

## Daftar Fitur
* **Multi-User Role:** Terbagi menjadi akses untuk Petugas dan Warga.
* **Authentication:** Login, Register (Email & Phone), OTP, dan verifikasi email via Supabase Auth.
* **Onboarding:** Panduan pengguna baru melalui Onboarding Pages.
* **Reporting:** Fitur lapor (Warga) dan manajemen laporan/kegiatan (Petugas).
* **Profile Management:** Edit profil dan manajemen akun.
* **Notifications:** Sistem notifikasi untuk update kegiatan atau laporan.

## Tech Stack
* **Framework:** Flutter 3.41.2
* **Language:** Dart
* **Backend as a Service:** Supabase (Authentication & PostgreSQL)
* **State Management:** Provider (MultiProvider & AuthProvider)
* **Design Tool:** Figma (UI/UX Design)
* **Image Handling:** Image Picker (untuk upload foto laporan)

## Arsitektur Aplikasi
Aplikasi ini menggunakan **Layered Architecture** yang dikelompokkan berdasarkan fungsionalitas dan peran pengguna:
* `lib/providers`: Mengelola logika bisnis dan autentikasi terpusat (AuthProvider).
* `lib/screens/umum`: Halaman publik seperti Splash Screen, Onboarding, dan pemilihan peran.
* `lib/screens/warga`: Seluruh fitur khusus untuk pengguna peran Warga (Report, Edukasi, Profil).
* `lib/screens/petugas`: Seluruh fitur khusus untuk petugas (Monitoring kegiatan, Detail laporan).
* `lib/main.dart`: Entry point aplikasi dan inisialisasi Supabase & MultiProvider.

## Cakupan Platform
* **Android:** Sudah diuji coba dan berjalan lancar pada perangkat fisik (HP Android) serta emulator.
* **iOS:** Kode sudah mendukung (compatible), namun proses pembuatan file instalasi (.ipa) memerlukan perangkat macOS dan Xcode untuk tahap build akhir.