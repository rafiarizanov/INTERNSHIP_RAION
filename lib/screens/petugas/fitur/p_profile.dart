import 'package:INTERNSHIP_RAION/providers/auth_provider.dart';
import 'package:INTERNSHIP_RAION/screens/petugas/fitur/p_tentang_aplikasi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class P_Profil extends StatefulWidget {
  const P_Profil({super.key});

  @override
  State<P_Profil> createState() => _P_ProfilState();
}

class _P_ProfilState extends State<P_Profil> {
  final Color primaryTeal = const Color(0xFF004D56);

  Future<void> _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).logoutPetugas();

    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final String namaPetugas = authProv.namaPetugas.isEmpty
        ? 'Petugas DLH'
        : authProv.namaPetugas;
    final String wilayahTugas = authProv.namaDaerah.isEmpty
        ? 'Wilayah Tidak Diketahui'
        : authProv.namaDaerah;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: primaryTeal,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: LayoutBuilder(
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
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      namaPetugas,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryTeal,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Petugas Lapangan - $wilayahTugas",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryTeal,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            Icons.info_outline,
                            'Tentang Aplikasi',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PTentangAplikasi(),
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
