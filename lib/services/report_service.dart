import 'package:supabase_flutter/supabase_flutter.dart';

class ReportService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchAllReports() async {
    final data = await _supabase.from('reports').select().order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> fetchDashboardReports(String selectedDaerah) async {
    var query = _supabase.from('reports').select();
    if (selectedDaerah != "Semua Daerah") {
      query = query.eq('lokasi', selectedDaerah);
    }
    final data = await query;
    return List<Map<String, dynamic>>.from(data);
  }


  Future<Map<String, dynamic>> fetchDashboardSummary({
    required String selectedDaerah,
    required String selectedBulan,
    required List<String> daftarBulan,
  }) async {
    var query = _supabase.from('reports').select();
    if (selectedDaerah != "Semua Daerah") {
      query = query.eq('lokasi', selectedDaerah);
    }
    final List<dynamic> dataLaporan = await query;

    int tempTotal = 0;
    int tempDiproses = 0;
    int tempSelesai = 0;
    Map<int, List<int>> tempChart = {};

    String targetMonthStr = (daftarBulan.indexOf(selectedBulan) + 1).toString().padLeft(2, '0');
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
          if (kategori == 'Siaga') tempChart[day]![0]++;
          else if (kategori == 'Waspada') tempChart[day]![1]++;
          else if (kategori == 'Darurat') tempChart[day]![2]++;
        }
      }
    }


    return {
      'total': tempTotal,
      'diproses': tempDiproses,
      'selesai': tempSelesai,
      'chartData': tempChart,
    };
  }

  
  Future<List<Map<String, dynamic>>> fetchComments(dynamic reportDbId) async {
    final data = await _supabase
        .from('report_comments')
        .select()
        .eq('report_id', reportDbId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<String> fetchSingleReportStatus(dynamic reportDbId) async {
    final data = await _supabase.from('reports').select('status').eq('id', reportDbId).single();
    return data['status'] ?? 'Belum Dibaca';
  }

  Future<void> postPetugasComment({
    required dynamic reportDbId,
    required dynamic userIdPelapor,
    required String userName,
    required String avatarUrl,
    required String message,
  }) async {
    await _supabase.from('report_comments').insert({
      'report_id': reportDbId,
      'user_name': userName,
      'avatar_url': avatarUrl,
      'role': 'Petugas',
      'message': message,
    });

    if (userIdPelapor != null) {
      await _supabase.from('notifications').insert({
        'target_user': userIdPelapor,
        'title': 'Pesan dari Petugas',
        'message': 'Petugas menanggapi laporan Anda: "$message"',
        'icon_type': 'chat',
        'report_id': reportDbId,
      });
    }
  }

  Future<void> updateReportStatus({
    required dynamic reportDbId,
    required String reportStringId,
    required dynamic userIdPelapor,
    required String newStatus,
  }) async {
    if (userIdPelapor != null) {
      await _supabase.from('notifications').insert({
        'target_user': userIdPelapor,
        'title': 'Status Laporan Berubah',
        'message': 'Status laporan Anda ($reportStringId) kini telah: $newStatus.',
        'icon_type': 'info',
        'report_id': reportDbId,
      });
    }
    await _supabase.from('reports').update({'status': newStatus}).eq('id', reportDbId);
  }
  Future<List<Map<String, dynamic>>> fetchPetugasNotifications() async {
    final data = await _supabase
        .from('notifications')
        .select()
        .eq('target_user', 'PETUGAS')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }
}