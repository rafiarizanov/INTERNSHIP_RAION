import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// PENTING: Sesuaikan path file w_edit_profile.dart milikmu
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_edit_profile.dart';

class WProfil extends StatefulWidget {
  const WProfil({super.key});

  @override
  State<WProfil> createState() => _WProfilState();
}

class _WProfilState extends State<WProfil> {
  final Color primaryTeal = const Color(0xFF004D56);
  final supabase = Supabase.instance.client;

  String _namaLengkap = "Memuat...";
  String _tanggalLahir = "-";
  String _avatarUrl = "";

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Mengambil data terbaru langsung dari server Supabase
  Future<void> _loadUserProfile() async {
    final response = await supabase.auth.getUser();
    final user = response.user;

    if (user != null) {
      final metadata = user.userMetadata;
      if (mounted) {
        setState(() {
          _namaLengkap = metadata?['display_name'] ?? 'Warga SadarAir';
          _tanggalLahir = metadata?['dob'] ?? '-';
          _avatarUrl = metadata?['avatar_url'] ?? '';
        });
      }
    }
  }

  Future<void> _logout() async {
    await supabase.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Akun dan Profil',
          style: TextStyle(
            color: primaryTeal,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserProfile,
        color: primaryTeal,
        backgroundColor: Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          // Menampilkan foto asli dari Supabase
                          backgroundImage: _avatarUrl.isNotEmpty
                              ? NetworkImage(_avatarUrl)
                              : null,
                          child: _avatarUrl.isEmpty
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey[500],
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        _namaLengkap,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryTeal,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        'Warga',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryTeal,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cake_outlined,
                            size: 16,
                            color: primaryTeal.withOpacity(0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _tanggalLahir,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryTeal,
                            ),
                          ),
                        ],
                      ),

                      // Mendorong menu ke bawah
                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              Icons.edit,
                              'Edit Profil',
                              onTap: () async {
                                // Tunggu pengguna selesai mengedit
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const W_EditProfil(),
                                  ),
                                );
                                // Refresh gambar secara paksa dan muat data terbaru
                                PaintingBinding.instance.imageCache.clear();
                                PaintingBinding.instance.imageCache
                                    .clearLiveImages();
                                await _loadUserProfile();
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildMenuItem(
                              Icons.info,
                              'Tentang Aplikasi',
                              onTap: () {},
                            ),
                            const SizedBox(height: 12),
                            _buildMenuItem(
                              Icons.logout,
                              'Logout',
                              onTap: _logout,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryTeal, size: 28),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: primaryTeal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
