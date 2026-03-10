import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: W_EditProfil(),
  ));
}

class W_EditProfil extends StatefulWidget {
  const W_EditProfil({super.key});

  @override
  State<W_EditProfil> createState() => _W_EditProfilState();
}

class _W_EditProfilState extends State<W_EditProfil> {
  final Color primaryTeal = const Color(0xFF003D4C);

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
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: primaryTeal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              'Edit Profil',
              style: TextStyle(
                color: primaryTeal,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 20),
           
            const Center(
              child: CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=32'),
              ),
            ),
            const SizedBox(height: 15),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: primaryTeal,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    "Ubah Foto Profil",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _buildInputLabel("Nama"),
            Row(
              children: [
                Expanded(child: _buildInputField(hint: "Nama Depan")),
                const SizedBox(width: 12),
                Expanded(child: _buildInputField(hint: "Nama Belakang")),
              ],
            ),

            _buildInputLabel("Tanggal Lahir"),
            _buildInputField(hint: "DD/MM/YYYY"),

            _buildInputLabel("Nomor Telepon"),
            _buildInputField(hint: "08XXXXXXX"),

            _buildInputLabel("Email"),
            _buildInputField(hint: "example@email.com"),

            const SizedBox(height: 50),

            
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: primaryTeal,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  "Simpan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  
  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 15),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: primaryTeal,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({String hint = ""}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: primaryTeal.withOpacity(0.5), fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: primaryTeal, width: 1.5),
          ),
        ),
      ),
    );
  }
}