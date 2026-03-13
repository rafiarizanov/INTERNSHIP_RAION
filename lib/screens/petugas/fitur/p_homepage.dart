import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/providers/auth_provider.dart';
import 'package:INTERNSHIP_RAION/screens/petugas/fitur/p_notifikasi.dart';
import 'package:INTERNSHIP_RAION/services/report_service.dart';
import 'p_kegiatan.dart';
import 'package:INTERNSHIP_RAION/screens/petugas/fitur/p_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPetugas,
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
            offset: const Offset(0, -5),
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
          color: isSelected ? AppColors.secondaryPetugas : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black87,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: isSelected
                  ? AppTextStyles.bodyBold.copyWith(color: Colors.white)
                  : AppTextStyles.bodyMid.copyWith(color: Colors.black87),
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
      final summary = await ReportService().fetchDashboardSummary(
        selectedDaerah: selectedDaerah,
        selectedBulan: selectedBulan,
        daftarBulan: daftarBulan,
      );

      if (mounted) {
        setState(() {
          _totalLaporan = summary['total'];
          _totalDiproses = summary['diproses'];
          _totalSelesai = summary['selesai'];
          _chartData = summary['chartData'];
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
                    style: AppTextStyles.h2Bold.copyWith(
                      color: AppColors.primaryPetugas,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(
                            items[index],
                            style: AppTextStyles.title2,
                          ),
                          value: items[index],
                          groupValue: tempSelected,
                          activeColor: AppColors.primaryPetugas,
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
                            backgroundColor: AppColors.blueLightActive,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            "Batal",
                            style: AppTextStyles.title1Bold.copyWith(
                              color: AppColors.primaryPetugas,
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
                            backgroundColor: AppColors.primaryPetugas,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            "Pilih",
                            style: AppTextStyles.title1Bold.copyWith(
                              color: Colors.white,
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
            onRefresh: _fetchDashboardData,
            color: AppColors.primaryPetugas,
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
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.primaryPetugas,
                                ),
                              ),
                              Text(
                                authProv.namaDaerah.isEmpty
                                    ? 'Budi Santoso!'
                                    : '${authProv.namaDaerah}!',
                                style: AppTextStyles.title2Bold.copyWith(
                                  color: AppColors.primaryPetugas,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PNotifikasi(),
                          ),
                        ),
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: AppColors.primaryPetugas,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Ringkasan Laporan",
                    style: AppTextStyles.title2Bold.copyWith(
                      color: AppColors.primaryPetugas,
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
                          AppColors.blueLightActive,
                          AppColors.blueDarkActive,
                          Icons.library_books,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          "Diproses",
                          _totalDiproses.toString(),
                          AppColors.statusDiprosesBg,
                          AppColors.statusDiprosesText,
                          Icons.autorenew_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          "Selesai",
                          _totalSelesai.toString(),
                          AppColors.statusSelesaiBg,
                          AppColors.statusSelesaiText,
                          Icons.check_circle_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Grafik Laporan",
                    style: AppTextStyles.title2Bold.copyWith(
                      color: AppColors.primaryPetugas,
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
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryPetugas,
                ),
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
              style: AppTextStyles.body.copyWith(color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.blueLightActive,
            child: Icon(
              Icons.chevron_right,
              size: 14,
              color: AppColors.primaryPetugas,
            ),
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
            style: AppTextStyles.captionBold.copyWith(color: darkBg),
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
              style: AppTextStyles.title2Bold.copyWith(color: Colors.white),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 10),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "Banyak Laporan",
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.black54,
                    ),
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
              _buildLegend(AppColors.blueNormal, "Siaga"),
              const SizedBox(width: 15),
              _buildLegend(AppColors.blueDark, "Waspada"),
              const SizedBox(width: 15),
              _buildLegend(AppColors.primaryPetugas, "Darurat"),
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
            _buildBar(h1, AppColors.blueNormal, v1.toString()),
            const SizedBox(width: 5),
            _buildBar(h2, AppColors.blueDark, v2.toString()),
            const SizedBox(width: 5),
            _buildBar(h3, AppColors.primaryPetugas, v3.toString()),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: AppTextStyles.captionBold.copyWith(color: Colors.black54),
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
            style: AppTextStyles.captionBold.copyWith(
              color: isZero ? Colors.grey.shade400 : color,
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
                      style: AppTextStyles.captionBold.copyWith(
                        color: Colors.white,
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
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primaryPetugas,
          ),
        ),
      ],
    );
  }
}
