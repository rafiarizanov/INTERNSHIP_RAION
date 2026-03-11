import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'p_detail_laporan.dart'; 

class PKegiatan extends StatefulWidget {
  const PKegiatan({super.key});

  @override
  State<PKegiatan> createState() => _PKegiatanState();
}

class _PKegiatanState extends State<PKegiatan> {
  String _selectedFilter = "Semua";
  final supabase = Supabase.instance.client;

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
      final data = await supabase
          .from('reports')
          .select()
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _allReports = List<Map<String, dynamic>>.from(data);
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
          (status == "Belum Dibaca" || status == "Laporan Diterima"))
        return true;
      if (_selectedFilter == "Dibaca" && status == "Laporan Dibaca")
        return true;
      if (_selectedFilter == "Diproses" && status == "Laporan Diproses")
        return true;
      if (_selectedFilter == "Selesai" && status == "Laporan Selesai")
        return true;
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final reportsToDisplay = _filteredReports;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Laporan Masalah Air",
          style: TextStyle(
            color: Color(0xFF004D56),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
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
              children: _filters.map((filterName) {
                return _buildFilterChip(
                  filterName,
                  _selectedFilter == filterName,
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF004D56)),
                  )
                : reportsToDisplay.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada laporan di kategori ini.",
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchReports,
                    color: const Color(0xFF004D56),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: reportsToDisplay.length,
                      itemBuilder: (context, index) {
                        final rep = reportsToDisplay[index];
                        return _buildReportCard(rep);
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
      ),
    );
  }

 
  Widget _buildReportCard(Map<String, dynamic> report) {
    String status = report['status'] ?? 'Belum Dibaca';
    Color statusBg = Colors.grey.shade300;
    Color statusText = Colors.grey.shade800;

   
    if (status == 'Laporan Dibaca') {
      statusBg = const Color(0xFFBDE7F1);
      statusText = const Color(0xFF00838F);
    } else if (status == 'Laporan Diproses') {
      statusBg = const Color(0xFFFFF1AD);
      statusText = const Color(0xFFB48A00);
    } else if (status == 'Laporan Selesai') {
      statusBg = const Color(0xFFC8E6C9);
      statusText = const Color(0xFF2E7D32);
    } else {
      statusBg = const Color(0xFFE0E0E0);
      statusText = const Color(0xFF616161);
      status = 'Diterima'; // Alias
    }

    String judulLaporan = report['deskripsi'] ?? 'Laporan Warga';
    List<String> kata = judulLaporan.split(' ');
    if (kata.length > 4) judulLaporan = "${kata.sublist(0, 4).join(' ')}...";

    return GestureDetector(
      onTap: () {
      
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDetailLaporan(report: report),
          ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusText,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Color(0xFF004D56),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              judulLaporan,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004D56),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              report['deskripsi'] ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.blueGrey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildIconText(Icons.tag, report['report_id'] ?? '-'),
                const SizedBox(width: 15),
                _buildIconText(
                  Icons.location_on_outlined,
                  report['lokasi'] ?? '-',
                ),
                const SizedBox(width: 15),
                _buildIconText(
                  Icons.calendar_today_outlined,
                  report['tanggal'] ?? '-',
                ),
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
        Icon(icon, size: 16, color: const Color(0xFF004D56)),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: Color(0xFF004D56)),
        ),
      ],
    );
  }
}
