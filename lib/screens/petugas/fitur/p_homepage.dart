import 'package:INTERNSHIP_RAION/providers/auth_provider.dart';
import 'p_kegiatan.dart';
import 'package:INTERNSHIP_RAION/screens/petugas/fitur/p_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class P_Homepage extends StatefulWidget {
  const P_Homepage({super.key});

  @override
  State<P_Homepage> createState() => _P_HomepageState();
}

class _P_HomepageState extends State<P_Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const P_DashboardContent(),
    const PKegiatan(),
    const P_Profil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      body: _pages[_selectedIndex],

      bottomNavigationBar: _buildCustomNavBar(),
    );
  }

  Widget _buildCustomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5), // Bayangan ke atas
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.bar_chart, 'Dashboard'),
            _buildNavItem(1, Icons.handyman_outlined, 'Kegiatan'),
            _buildNavItem(2, Icons.person_outline, 'Akun'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00838F) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class P_DashboardContent extends StatefulWidget {
  const P_DashboardContent({super.key});

  @override
  State<P_DashboardContent> createState() => _P_DashboardContentState();
}

class _P_DashboardContentState extends State<P_DashboardContent> {
  String selectedDaerah = "Semua Daerah";
  String selectedBulan = "";

  final Color primaryTeal = const Color(0xFF004D56);
  final supabase = Supabase.instance.client;

  bool _isLoadingData = true;
  int _totalLaporan = 0;
  int _totalDiproses = 0;
  int _totalSelesai = 0;
  Map<int, List<int>> _chartData = {};

  final List<String> daftarBulan = [
    "Januari",
    "Februari",
    "Maret",
    "April",
    "Mei",
    "Juni",
    "Juli",
    "Agustus",
    "September",
    "Oktober",
    "November",
    "Desember",
  ];

  @override
  void initState() {
    super.initState();
    selectedBulan = daftarBulan[DateTime.now().month - 1];
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() => _isLoadingData = true);

    try {
      var query = supabase.from('reports').select();
      if (selectedDaerah != "Semua Daerah") {
        query = query.eq('lokasi', selectedDaerah);
      }

      final List<dynamic> dataLaporan = await query;

      int tempTotal = 0;
      int tempDiproses = 0;
      int tempSelesai = 0;
      Map<int, List<int>> tempChart = {};

      String targetMonthStr = (daftarBulan.indexOf(selectedBulan) + 1)
          .toString()
          .padLeft(2, '0');
      String currentYearStr = DateTime.now().year.toString();

      for (var report in dataLaporan) {
        String tanggal = report['tanggal'] ?? '';

        if (tanggal.length >= 10) {
          String dayStr = tanggal.substring(0, 2);
          String monthStr = tanggal.substring(3, 5);
          String yearStr = tanggal.substring(6, 10);

          if (monthStr == targetMonthStr && yearStr == currentYearStr) {
            tempTotal++;

            String status = report['status'] ?? 'Belum Dibaca';
            if (status == 'Laporan Diproses') tempDiproses++;
            if (status == 'Laporan Selesai') tempSelesai++;

            int day = int.tryParse(dayStr) ?? 1;
            String kategori = report['kategori'] ?? '';

            tempChart.putIfAbsent(day, () => [0, 0, 0]);
            if (kategori == 'Siaga')
              tempChart[day]![0]++;
            else if (kategori == 'Waspada')
              tempChart[day]![1]++;
            else if (kategori == 'Darurat')
              tempChart[day]![2]++;
          }
        }
      }

      if (mounted) {
        setState(() {
          _totalLaporan = tempTotal;
          _totalDiproses = tempDiproses;
          _totalSelesai = tempSelesai;
          _chartData = tempChart;
          _isLoadingData = false;
        });
      }
    } catch (e) {
      debugPrint("Gagal menarik data dashboard: $e");
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  void _showDaerahPicker() {
    final List<String> daftarDaerah = [
      "Semua Daerah",
      "Bekasi Barat",
      "Bekasi Utara",
      "Bekasi Timur",
      "Bekasi Selatan",
      "Jatiasih",
      "Jatisampurna",
      "Medan Satria",
      "Mustika Jaya",
      "Pondok Melati",
      "Bantar Gebang",
      "Pondok Gede",
    ];
    _showGenericPicker("Pilih Daerah", daftarDaerah, selectedDaerah, (val) {
      setState(() {
        selectedDaerah = val;
        _fetchDashboardData();
      });
    });
  }

  void _showBulanPicker() {
    _showGenericPicker("Pilih Bulan", daftarBulan, selectedBulan, (val) {
      setState(() {
        selectedBulan = val;
        _fetchDashboardData();
      });
    });
  }

  void _showGenericPicker(
    String title,
    List<String> items,
    String currentVal,
    Function(String) onSave,
  ) {
    String tempSelected = currentVal;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryTeal,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(items[index]),
                          value: items[index],
                          groupValue: tempSelected,
                          activeColor: primaryTeal,
                          onChanged: (value) =>
                              setModalState(() => tempSelected = value!),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              color: primaryTeal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                            backgroundColor: primaryTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            "Pilih",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

    return SafeArea(
      child: Stack(
        children: [
         
          RefreshIndicator(
            onRefresh:
                _fetchDashboardData, 
            color: primaryTeal,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
             
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(
                              'assets/image/logo.png',
                            ),
                            backgroundColor: Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo,',
                                style: TextStyle(
                                  color: primaryTeal,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                authProv.namaDaerah.isEmpty
                                    ? 'Budi Santoso!'
                                    : '${authProv.namaDaerah}!',
                                style: TextStyle(
                                  color: primaryTeal,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_none_rounded,
                          color: primaryTeal,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                 
                  Text(
                    "Ringkasan Laporan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryTeal,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _showDaerahPicker,
                          child: _buildDropdown(selectedDaerah),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: _showBulanPicker,
                          child: _buildDropdown(selectedBulan),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          "Total Laporan",
                          _totalLaporan.toString(),
                          const Color(0xFFB2EBF2),
                          const Color(0xFF006B7D),
                          Icons.library_books,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          "Diproses",
                          _totalDiproses.toString(),
                          const Color(0xFFFDE68A),
                          const Color(0xFF92700B),
                          Icons.autorenew_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          "Selesai",
                          _totalSelesai.toString(),
                          const Color(0xFFA5D6A7),
                          const Color(0xFF004D1A),
                          Icons.check_circle_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

               
                  Text(
                    "Grafik Laporan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryTeal,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildChartSection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          if (_isLoadingData)
            Container(
              color: Colors.white.withOpacity(0.6),
              child: Center(
                child: CircularProgressIndicator(color: primaryTeal),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              hint,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CircleAvatar(
            radius: 10,
            backgroundColor: const Color(0xFFB2EBF2),
            child: Icon(Icons.chevron_right, size: 14, color: primaryTeal),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(
    String title,
    String count,
    Color lightBg,
    Color darkBg,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      decoration: BoxDecoration(
        color: lightBg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: darkBg, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkBg,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: darkBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getDaysInMonth(String monthName) {
    int month = daftarBulan.indexOf(monthName) + 1;
    if (month == 0) month = 1;
    return DateTime(DateTime.now().year, month + 1, 0).day;
  }

  List<Widget> _buildScrollableBars() {
    int days = _getDaysInMonth(selectedBulan);
    List<Widget> bars = [];

    double maxValue = 5.0;
    for (var values in _chartData.values) {
      for (var v in values) {
        if (v > maxValue) maxValue = v.toDouble();
      }
    }

    double maxChartScale = ((maxValue / 5).ceil() * 5).toDouble();
    double maxPixelHeight = 130.0;

    for (int i = 1; i <= days; i++) {
      int siaga = 0;
      int waspada = 0;
      int darurat = 0;

      if (_chartData.containsKey(i)) {
        siaga = _chartData[i]![0];
        waspada = _chartData[i]![1];
        darurat = _chartData[i]![2];
      }

      double h1 = (siaga / maxChartScale) * maxPixelHeight;
      double h2 = (waspada / maxChartScale) * maxPixelHeight;
      double h3 = (darurat / maxChartScale) * maxPixelHeight;

      bars.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: _buildBarGroup(
            i.toString(),
            h1,
            h2,
            h3,
            siaga,
            waspada,
            darurat,
          ),
        ),
      );
    }
    return bars;
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "Banyak Laporan",
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: SizedBox(
                  height: 180,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _buildScrollableBars(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(const Color(0xFF00B8D4), "Siaga"),
              const SizedBox(width: 15),
              _buildLegend(const Color(0xFF00838F), "Waspada"),
              const SizedBox(width: 15),
              _buildLegend(const Color(0xFF004D56), "Darurat"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarGroup(
    String label,
    double h1,
    double h2,
    double h3,
    int v1,
    int v2,
    int v3,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBar(h1, const Color(0xFF00B8D4), v1.toString()),
            const SizedBox(width: 5),
            _buildBar(h2, const Color(0xFF00838F), v2.toString()),
            const SizedBox(width: 5),
            _buildBar(h3, const Color(0xFF004D56), v3.toString()),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBar(double height, Color color, String value) {
    bool isZero = value == "0";

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isZero || height < 20)
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              color: isZero ? Colors.grey.shade400 : color,
              fontWeight: FontWeight.bold,
            ),
          ),

        const SizedBox(height: 2),

        Container(
          width: 20,
          height: isZero ? 4 : height,
          decoration: BoxDecoration(
            color: isZero ? Colors.grey.shade200 : color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: (!isZero && height >= 20)
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: Color(0xFF004D56)),
        ),
      ],
    );
  }
}
