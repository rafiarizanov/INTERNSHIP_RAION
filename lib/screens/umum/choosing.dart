import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../warga/masuk_daftar/w_registration_email.dart';
import '../petugas/masuk/p_sign_in.dart';

class ChoosingPage extends StatefulWidget {
  const ChoosingPage({super.key});

  @override
  State<ChoosingPage> createState() => _ChoosingPageState();
}

class _ChoosingPageState extends State<ChoosingPage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pilih Peran Anda',
                  style: AppTextStyles.h3Bold.copyWith(color: AppColors.primaryPetugas),
                ),
                const SizedBox(height: 40),

               
                GestureDetector(
                  onTap: () => setState(() => selectedRole = 'warga'),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: selectedRole == 'warga'
                          ? AppColors.blueDarkActive.withOpacity(0.8)
                          : AppColors.blueLightActive,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: double.infinity,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset('assets/image/warga.png', fit: BoxFit.cover),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15, top: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Warga',
                                  style: AppTextStyles.h2Bold.copyWith(
                                    color: selectedRole == 'warga' ? Colors.white : AppColors.primaryPetugas,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Laporkan masalah air bersih dan dapatkan edukasi terkait sanitasi.',
                                  style: AppTextStyles.body.copyWith(
                                    color: selectedRole == 'warga' ? Colors.white70 : AppColors.primaryPetugas.withOpacity(0.8),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

             
                GestureDetector(
                  onTap: () => setState(() => selectedRole = 'petugas'),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: selectedRole == 'petugas'
                          ? AppColors.blueDarkActive.withOpacity(0.8)
                          : AppColors.blueLightActive,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: double.infinity,
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset('assets/image/petugas.png', fit: BoxFit.cover),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15, top: 20, bottom: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Petugas',
                                  style: AppTextStyles.h2Bold.copyWith(
                                    color: selectedRole == 'petugas' ? Colors.white : AppColors.primaryPetugas,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pantau dan tangani laporan warga terkait masalah air bersih.',
                                  style: AppTextStyles.body.copyWith(
                                    color: selectedRole == 'petugas' ? Colors.white70 : AppColors.primaryPetugas.withOpacity(0.8),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

            
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedRole == 'warga') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const WRegistrationEmail()));
                      } else if (selectedRole == 'petugas') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PSignIn()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Silakan pilih peran!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blueDarker, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: Text(
                      'Lanjut',
                      style: AppTextStyles.title2Bold.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}