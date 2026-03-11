import 'package:INTERNSHIP_RAION/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../masuk/p_sign_in.dart';


class P_Homepage extends StatefulWidget {
  const P_Homepage({super.key});

  @override
  State<P_Homepage> createState() => _P_HomepageState();
}

class _P_HomepageState extends State<P_Homepage> {
  String selectedDaerah = "Pilih Daerah";
  String selectedBulan = "Pilih Bulan";

  void _showDaerahPicker() {
    final List<String> daftarDaerah = [
      "Bekasi Barat", "Bekasi Utara", "Bekasi Timur", "Bekasi Selatan",
      "Jatiasih", "Jatisampurna", "Medan Satria", "Mustika Jaya",
      "Pondok Melati", "Bantar Gebang", "Pondok Gede"
    ];
    _showGenericPicker("Pilih Daerah", daftarDaerah, selectedDaerah, (val) {
      setState(() => selectedDaerah = val);
    });
  }

  void _showBulanPicker() {
    final List<String> daftarBulan = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    _showGenericPicker("Pilih Bulan", daftarBulan, selectedBulan, (val) {
      setState(() => selectedBulan = val);
    });
  }

  void _showGenericPicker(String title, List<String> items, String currentVal, Function(String) onSave) {
    String tempSelected = currentVal;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D56))),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(items[index]),
                          value: items[index],
                          groupValue: tempSelected,
                          activeColor: const Color(0xFF004D56),
                          onChanged: (value) => setModalState(() => tempSelected = value!),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade100,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text("Batal", style: TextStyle(color: Color(0xFF004D56), fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            onSave(tempSelected);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004D56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text("Pilih", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFB),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            const CircleAvatar(radius: 24, backgroundColor: Colors.grey),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Halo,', style: TextStyle(color: Color(0xFF004D56), fontSize: 14)),
                Text(
                  authProv.namaDaerah.isEmpty ? 'Budi Santoso!' : authProv.namaDaerah,
                  style: const TextStyle(color: Color(0xFF004D56), fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF004D56), size: 28)),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ringkasan Laporan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D56))),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: GestureDetector(
                  onTap: _showDaerahPicker,
                  child: _buildDropdown(selectedDaerah),
                )),
                const SizedBox(width: 15),
                Expanded(child: GestureDetector(
                  onTap: _showBulanPicker,
                  child: _buildDropdown(selectedBulan),
                )),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBox("Total Laporan", "145", const Color(0xFFB3E5FC), const Color(0xFF006064), Icons.description_outlined),
                _buildStatBox("Diproses", "90", const Color(0xFFFFF176), const Color(0xFF827717), Icons.autorenew_rounded),
                _buildStatBox("Selesai", "55", const Color(0xFFC8E6C9), const Color(0xFF1B5E20), Icons.assignment_turned_in_outlined),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Grafik Laporan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D56))),
            const SizedBox(height: 15),
            _buildChartSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavbar(0),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(hint, style: TextStyle(color: Colors.grey.shade600, fontSize: 13), overflow: TextOverflow.ellipsis)),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.cyan.shade200),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String count, Color bgColor, Color darkColor, IconData icon) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bgColor.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Icon(icon, color: darkColor.withOpacity(0.7), size: 24),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: darkColor, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(color: darkColor, borderRadius: BorderRadius.circular(10)),
            child: Text(count, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarGroup("11/2", 100, 140),
                _buildBarGroup("12/2", 120, 90),
                _buildBarGroup("13/2", 80, 100),
                _buildBarGroup("14/2", 120, 140),
                _buildBarGroup("15/2", 90, 110),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(const Color(0xFF00B8D4), "Siaga"),
              const SizedBox(width: 20),
              _buildLegend(const Color(0xFF006064), "Waspada"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBarGroup(String label, double h1, double h2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBar(h1, const Color(0xFF00B8D4), (h1 / 10).toInt().toString()),
            const SizedBox(width: 4),
            _buildBar(h2, const Color(0xFF006064), (h2 / 10).toInt().toString()),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildBar(double height, Color color, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
        Container(
          width: 18,
          height: height,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF004D56))),
      ],
    );
  }
}

Widget _buildNavbar(int index) {
  return Container(
    decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
    child: BottomNavigationBar(
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF00838F),
      unselectedItemColor: Colors.black87,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFF00838F), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.bar_chart, color: Colors.white),
          ),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.handyman_outlined), label: 'Kegiatan'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
      ],
    ),
  );
}