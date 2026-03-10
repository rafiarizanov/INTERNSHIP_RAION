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
                  color: const Color(0xFF004D56),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF004D56), 
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20, left: 10),
            child: Text('2/2', style: TextStyle(color: Color(0xFF004D56), fontWeight: FontWeight.bold)),
          )
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
              const Text(
                'Anda Telah Terdaftar\nSebagai Warga',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D56),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Anda kini dapat masuk dan mulai mengirim\nlaporan untuk membantu meningkatkan kualitas\nair dan sanitasi di Kota Bekasi.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF004D56),
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
                    color: const Color(0xFF004D56),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      'Mulai Berkontribusi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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