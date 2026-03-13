import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/screens/umum/tentang_aplikasi.dart';
import 'package:INTERNSHIP_RAION/services/warga_service.dart';
import 'package:flutter/material.dart';
import 'package:INTERNSHIP_RAION/screens/warga/fitur/w_edit_profile.dart';

class WProfil extends StatefulWidget {
  const WProfil({super.key});

  @override
  State<WProfil> createState() => _WProfilState();
}

class _WProfilState extends State<WProfil> {
  String _namaLengkap = "Memuat...";
  String _tanggalLahir = "-";
  String _avatarUrl = "";

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userData = await WargaService().getUserProfile();
    if (mounted && userData.isNotEmpty) {
      setState(() {
        _namaLengkap = userData['name'];
        _tanggalLahir = userData['dob'];
        _avatarUrl = userData['avatar_url'];
      });
    }
  }


  Future<void> _logout() async {
    await WargaService().logout();
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
          style: AppTextStyles.h2Bold.copyWith(color: AppColors.blueDarker),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserProfile,
        color: AppColors.blueDarker,
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
                        style: AppTextStyles.h3Bold.copyWith(
                          color: AppColors.blueDarker,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Warga',
                        style: AppTextStyles.title1Bold.copyWith(
                          color: AppColors.blueDarker,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cake_outlined,
                            size: 16,
                            color: AppColors.blueDarker.withOpacity(0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _tanggalLahir,
                            style: AppTextStyles.title1Bold.copyWith(
                              color: AppColors.blueDarker,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            _buildMenuItem(
                              Icons.edit,
                              'Edit Profil',
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const W_EditProfil(),
                                  ),
                                );
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TentangAplikasi(),
                                  ),
                                );
                              },
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
            Icon(icon, color: AppColors.blueDarker, size: 28),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyles.title1Bold.copyWith(
                color: AppColors.blueDarker,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
