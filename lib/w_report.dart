import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: W_ReportPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class W_ReportPage extends StatefulWidget {
  const W_ReportPage({super.key});

  @override
  State<W_ReportPage> createState() => _W_ReportPageState();
}

class _W_ReportPageState extends State<W_ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Laporkan Masalah Air',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003D45),
                    ),
                  ),
                  const Icon(Icons.history, color: Color(0xFF003D45), size: 28),
                ],
              ),
              const SizedBox(height: 25),
              _buildLabel("Tanggal"),
              _buildInputField("Masukkan Tanggal", Icons.calendar_today_outlined),
              _buildLabel("Lokasi"),
              _buildDropdownField("Pilih Daerah"),
              _buildLabel("Kategori"),
              _buildDropdownField("Pilih Kategori"),
              _buildLabel("Deskripsi"),
              _buildTextAreaField("Jelaskan Keluhan Anda"),
              _buildLabel("Unggah Bukti"),
              _buildUploadField("Upload Gambar"),
              const SizedBox(height: 30),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildLockedNavbar(),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF003D45),
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF709096)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF709096), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF003D45), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF709096)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Color(0xFF709096), fontSize: 14)),
          const Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFF80DEEA), size: 22),
        ],
      ),
    );
  }

  Widget _buildTextAreaField(String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF709096)),
      ),
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF709096), fontSize: 14),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 60),
            child: Icon(Icons.menu, color: Color(0xFF003D45), size: 22),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildUploadField(String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF709096)),
      ),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF709096), fontSize: 14),
          prefixIcon: const Icon(Icons.file_upload_outlined, color: Color(0xFF003D45), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF004D56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Kirim ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedNavbar() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF003D45),
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: (index) {
          // Locked: No action
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF007E94),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.notifications_active),
            ),
            label: 'Report',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Edukasi',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}