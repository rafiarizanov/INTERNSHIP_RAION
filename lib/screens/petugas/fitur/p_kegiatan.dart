import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/services/report_service.dart';
import 'package:flutter/material.dart';
import 'p_detail_laporan.dart';

class PKegiatan extends StatefulWidget {
  const PKegiatan({super.key});

  @override
  State<PKegiatan> createState() => _PKegiatanState();
}

class _PKegiatanState extends State<PKegiatan> {
  String _selectedFilter = "Semua";

  final List<String> _filters = [
    "Semua",
    "Diterima",
    "Dibaca",
    "Diproses",
    "Selesai",
  ];

  List<Map<String, dynamic>> _allReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    setState(() => _isLoading = true);
    try {
      final data = await ReportService().fetchAllReports();
      if (mounted) {
        setState(() {
          _allReports = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching reports: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Map<String, dynamic>> get _filteredReports {
    if (_selectedFilter == "Semua") {
      return _allReports;
    }
    return _allReports.where((report) {
      String status = report["status"] ?? "Belum Dibaca";
      if (_selectedFilter == "Diterima" &&
          (status == "Belum Dibaca" || status == "Laporan Diterima")) return true;
      if (_selectedFilter == "Dibaca" && status == "Laporan Dibaca") return true;
      if (_selectedFilter == "Diproses" && status == "Laporan Diproses") return true;
      if (_selectedFilter == "Selesai" && status == "Laporan Selesai") return true;
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final reportsToDisplay = _filteredReports;

    return Scaffold(
      backgroundColor: AppColors.bgPetugas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Laporan Masalah Air",
          style: AppTextStyles.h2Bold.copyWith(color: AppColors.primaryPetugas),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                const Icon(Icons.filter_list_alt, color: AppColors.primaryPetugas),
                const SizedBox(width: 10),
                Text(
                  "Filter Status",
                  style: AppTextStyles.title2Mid.copyWith(color: Colors.blueGrey.shade700),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: Row(
              children: _filters.map((filterName) {
                return _buildFilterChip(filterName, _selectedFilter == filterName);
              }).toList(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPetugas))
                : reportsToDisplay.isEmpty
                ? Center(
                    child: Text("Tidak ada laporan di kategori ini.", style: AppTextStyles.body.copyWith(color: Colors.blueGrey)),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchReports,
                    color: AppColors.primaryPetugas,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: reportsToDisplay.length,
                      itemBuilder: (context, index) {
                        return _buildReportCard(reportsToDisplay[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPetugas : const Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.title1Bold.copyWith(color: isSelected ? Colors.white : AppColors.primaryPetugas),
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    String status = report['status'] ?? 'Belum Dibaca';
    Color statusBg = AppColors.statusBelumDibacaBg;
    Color statusText = AppColors.statusBelumDibacaText;

    if (status == 'Laporan Dibaca') {
      statusBg = AppColors.statusDibacaBg; statusText = AppColors.statusDibacaText;
    } else if (status == 'Laporan Diproses') {
      statusBg = AppColors.statusDiprosesBg; statusText = AppColors.statusDiprosesText;
    } else if (status == 'Laporan Selesai') {
      statusBg = AppColors.statusSelesaiBg; statusText = AppColors.statusSelesaiText;
    } else {
      status = 'Diterima'; 
    }

    String judulLaporan = report['deskripsi'] ?? 'Laporan Warga';
    List<String> kata = judulLaporan.split(' ');
    if (kata.length > 4) judulLaporan = "${kata.sublist(0, 4).join(' ')}...";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PDetailLaporan(report: report)),
        ).then((_) => _fetchReports());
      },
      child: Container(
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
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10)),
                  child: Text(status, style: AppTextStyles.captionBold.copyWith(color: statusText)),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryPetugas),
              ],
            ),
            const SizedBox(height: 10),
            Text(judulLaporan, style: AppTextStyles.h1Bold.copyWith(color: AppColors.primaryPetugas)),
            const SizedBox(height: 6),
            Text(
              report['deskripsi'] ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(color: Colors.blueGrey.shade600, height: 1.4),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildIconText(Icons.tag, report['report_id'] ?? '-'),
                const SizedBox(width: 15),
                _buildIconText(Icons.location_on_outlined, report['lokasi'] ?? '-'),
                const SizedBox(width: 15),
                _buildIconText(Icons.calendar_today_outlined, report['tanggal'] ?? '-'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryPetugas),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.caption.copyWith(color: AppColors.primaryPetugas)),
      ],
    );
  }
}