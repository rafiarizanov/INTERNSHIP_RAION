import 'package:flutter/material.dart';
import 'onboarding_page_3.dart';

class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({super.key});

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
      child: SingleChildScrollView(  
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              const SizedBox(height:96),
            Container(
              width: 210,
              height: 150,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.image, size: 75, color: Colors.black54),
                  const SizedBox(height: 10),
                  const Center ( 
                    child: Text(
                    'Gambar/ Icons yang PAGE 2',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  )
                  
                ],
              ),
            ),
            const SizedBox(height: 20),
              const SizedBox(height: 30,),

              Container(
                width: 274,
                height: 38,
                color: Colors.grey[300],
                child: const Center ( 
                  child: Text( 
                  'Judul Fitur (Teks)',
                  textAlign: TextAlign.center,
                  style: TextStyle ( 
                    fontSize: 14,
                    fontWeight:  FontWeight.w500,
                  ),
                )

                )
                
              ),
              const SizedBox(height:15),

              Container( 
                width: 262,
                height: 16,
                decoration: BoxDecoration( 
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center ( 
                  child: Text ( 
                    'teks penjelasan fitur',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            const SizedBox(height:15),
            Container( 
                width: 341,
                height: 14,
                decoration: BoxDecoration( 
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
            ),
          const SizedBox(height:200),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingPage3(),),);
            },
            child : Container( 
            width: 185,
            height: 31,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center( 
              child: Text ( 
                'Next (Button)',
                style: TextStyle(fontSize:14),
              )
            )
          ),
          )
          
          ],
        ),
      ),
      ),
    );
  }
}