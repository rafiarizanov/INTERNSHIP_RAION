import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../fitur/w_homepage.dart';

class WRegistrasiBerhasil extends StatelessWidget {
  const WRegistrasiBerhasil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryPetugas,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryPetugas,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 10),
            child: Text(
              '2/2',
              style: AppTextStyles.title1Bold.copyWith(
                color: AppColors.primaryPetugas,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(Icons.water_drop, size: 120, color: Colors.cyan[400]),
              const SizedBox(height: 30),
              Text(
                'Anda Telah Terdaftar\nSebagai Warga',
                textAlign: TextAlign.center,
                style: AppTextStyles.h3Bold.copyWith(
                  fontSize: 22,
                  color: AppColors.primaryPetugas,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Anda kini dapat masuk dan mulai mengirim\nlaporan untuk membantu meningkatkan kualitas\nair dan sanitasi di Kota Bekasi.',
                textAlign: TextAlign.center,
                style: AppTextStyles.title1.copyWith(
                  color: AppColors.primaryPetugas,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const W_Homepage()),
                    (route) => false,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPetugas,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Mulai Berkontribusi',
                      style: AppTextStyles.title2Bold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
