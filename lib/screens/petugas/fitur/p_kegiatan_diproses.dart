import 'package:flutter/material.dart';


class PKegiatan extends StatelessWidget {
  const PKegiatan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Laporan Masalah Air",
          style: TextStyle(
            color: Color(0xFF004D56),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Color(0xFF004D56)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                const Icon(Icons.filter_list_alt, color: Color(0xFF004D56)),
                const SizedBox(width: 10),
                Text(
                  "Filter Status",
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Row(
              children: [
                _buildFilterChip("Semua", false),
                _buildFilterChip("Diterima", false),
                _buildFilterChip("Dibaca", false),
                _buildFilterChip("Diproses", true), // Filter Diproses terpilih
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Hanya menampilkan informasi laporan berstatus "Laporan Diproses"
                _buildReportCard(
                  "Air Berbusa", 
                  "Air terlihat berbusa saat digunakan dan terasa licin di kulit meskipun tanpa sabun.", 
                  "LP004", 
                  "Medan Satria", 
                  "12/02/2026", 
                  "Laporan Diproses", 
                  const Color(0xFFFFF9C4), 
                  const Color(0xFFFBC02D)
                ),
                _buildReportCard(
                  "Air Mengandung Endapan", 
                  "Terdapat endapan pasir halus di dasar ember setelah air ditampung selama beberapa jam.", 
                  "LP005", 
                  "Jatiasih", 
                  "10/02/2026", 
                  "Laporan Diproses", 
                  const Color(0xFFFFF9C4), 
                  const Color(0xFFFBC02D)
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildNavbar(),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF004D56) : const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF004D56),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReportCard(String title, String desc, String id, String location, String date, String status, Color statusBg, Color statusText) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusText),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF004D56)),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D56))),
          const SizedBox(height: 6),
          Text(
            desc,
            style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade600, height: 1.4),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildIconText(Icons.tag, id),
              const SizedBox(width: 15),
              _buildIconText(Icons.location_on_outlined, location),
              const SizedBox(width: 15),
              _buildIconText(Icons.calendar_today_outlined, date),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF004D56)),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF004D56))),
      ],
    );
  }

  Widget _buildNavbar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.bar_chart, "Dashboard", false),
          _buildNavItem(Icons.handyman, "Kegiatan", true),
          _buildNavItem(Icons.person_outline, "Akun", false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF00838F) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isActive ? Colors.white : Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}