import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                    'Gambar/ Icons yang nantinya sesuai feature',
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
          Container( 
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
          ],
        ),
      ),
      ),
     
    );
  }
}