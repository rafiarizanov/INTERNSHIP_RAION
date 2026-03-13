# SadarAir - Mobile Application

💧 SadarAir

Aplikasi SadarAir adalah solusi manajemen air digital komprehensif yang dikembangkan menggunakan Flutter dengan integrasi Supabase. Aplikasi ini dirancang untuk memfasilitasi pelaporan warga dan manajemen penanganan oleh petugas secara efisien.

✨ Daftar Fitur

Multi-User Role: Akses terspesialisasi yang terbagi menjadi aplikasi untuk Petugas dan Warga.

Authentication: Sistem otentikasi yang aman meliputi Login, Register (Email & Nomor Telepon), verifikasi OTP, dan konfirmasi email via Supabase Auth.

Onboarding: Panduan interaktif bagi pengguna baru melalui Onboarding Pages.

Reporting: Fitur pelaporan isu air (Warga) dan dasbor manajemen laporan/kegiatan (Petugas).

Comment & Chat: Fitur komunikasi dua arah antara pelapor dan petugas langsung di dalam tiket laporan.

Profile Management: Personalisasi dan manajemen data akun pengguna.

Notifications: Sistem notifikasi terintegrasi untuk memberikan update status kegiatan atau laporan secara real-time.

🛠️ Tech Stack
Framework: Flutter 3.41.2

Language: Dart

Backend as a Service (BaaS): Supabase (Authentication & Cloud PostgreSQL)

State Management: Provider (MultiProvider & AuthProvider)

Design Tool: Figma (UI/UX Design)

Packages: Image Picker (untuk manajemen upload foto laporan)

🏗️ Arsitektur Sistem (Client-Server Architecture)
Sistem pada aplikasi ini dibagi menjadi dua User Interface (UI) utama, yaitu aplikasi Warga dan aplikasi Petugas, yang saling terhubung melalui Client-Server Architecture dengan rincian lapisan sebagai berikut:

1. Client Tier (Aplikasi Pengguna)
Pada sisi klien (Warga), terdapat antarmuka pelaporan yang mengemas input pengguna menjadi sebuah paket data komprehensif. Paket ini menyimpan deskripsi laporan, titik lokasi, kategori, serta lampiran gambar.

2. API & Authentication Layer (Supabase Auth)
Sebelum mengakses sistem, identitas pengguna divalidasi dengan ketat:

Warga: Divalidasi menggunakan Supabase Auth (Email / Nomor Telepon / Password) untuk mencegah akses anonim.

Petugas: Menggunakan Custom Database Auth dengan akses tertutup untuk menjaga kerahasiaan dan keamanan data instansi.

3. Database & Storage Layer (Supabase & PostgreSQL)
Infrastruktur penyimpanan dipisahkan berdasarkan tipe data untuk optimalisasi kinerja:

File Gambar: Diunggah dan disimpan di dalam Supabase Storage Bucket.

Data Teks/Relasional: Disimpan dan dikelola secara terstruktur ke dalam tabel PostgreSQL Database.

4. Real-time Synchronization (Aplikasi Petugas)
Sistem menggunakan sinkronisasi dinamis. Ketika sebuah laporan baru masuk dari aplikasi Warga, aplikasi Petugas akan menarik (fetch) data terbaru dari database secara real-time. Hal ini memastikan data yang ditampilkan pada grafik statistik dan daftar laporan selalu aktual (up-to-date).

📱 Cakupan Platform
🟢 Android: Sudah diuji coba secara menyeluruh dan berjalan lancar pada perangkat fisik (HP Android) serta Emulator.

🟡 iOS: Kode dasar sudah kompatibel (cross-platform). Namun, proses kompilasi akhir menjadi file instalasi (.ipa) memerlukan perangkat macOS dan aplikasi Xcode.