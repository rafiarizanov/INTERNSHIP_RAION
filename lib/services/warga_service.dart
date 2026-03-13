import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class WargaService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return {};
    final metadata = user.userMetadata;
    return {
      'id': user.id,
      'name': metadata?['display_name'] ?? 'Warga',
      'avatar_url': metadata?['avatar_url'] ?? '',
      'dob': metadata?['dob'] ?? '-',
      'email': user.email ?? '',
      'phone': metadata?['phone'] ?? '',
    };
  }

  Future<List<Map<String, dynamic>>> fetchLatestReports() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];
    final response = await _supabase
        .from('reports')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false)
        .limit(2);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchAllMyReports() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];
    final response = await _supabase
        .from('reports')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }


  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];
    final response = await _supabase
        .from('notifications')
        .select()
        .eq('target_user', user.id)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

 
  Future<List<Map<String, dynamic>>> fetchReportComments(dynamic reportDbId) async {
    final data = await _supabase.from('report_comments').select().eq('report_id', reportDbId).order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(data);
  }


  Future<String> fetchSingleReportStatus(dynamic reportDbId) async {
    final data = await _supabase.from('reports').select('status').eq('id', reportDbId).single();
    return data['status'] ?? 'Belum Dibaca';
  }


  Future<void> postWargaComment({required dynamic reportDbId, required String reportStringId, required String message}) async {
    final user = _supabase.auth.currentUser;
    final metadata = user?.userMetadata;
    final userName = metadata?['display_name'] ?? 'Warga';
    final avatarUrl = metadata?['avatar_url'] ?? '';

    await _supabase.from('report_comments').insert({
      'report_id': reportDbId,
      'user_name': userName,
      'avatar_url': avatarUrl,
      'role': 'Warga',
      'message': message,
    });

    await _supabase.from('notifications').insert({
      'target_user': 'PETUGAS',
      'title': 'Balasan Warga',
      'message': 'Warga membalas pada laporan $reportStringId: "$message"',
      'icon_type': 'chat'
    });
  }


  Future<void> deleteReport(dynamic reportDbId) async {
    await _supabase.from('reports').delete().eq('id', reportDbId);
  }


  Future<String> generateNewReportId(String daerahBaru) async {
    String prefix = "XX";
    switch (daerahBaru) {
      case "Bekasi Barat": prefix = "BB"; break;
      case "Bekasi Utara": prefix = "BU"; break;
      case "Bekasi Timur": prefix = "BT"; break;
      case "Bekasi Selatan": prefix = "BS"; break;
      case "Jatiasih": prefix = "JA"; break;
      case "Jatisampurna": prefix = "JS"; break;
      case "Medan Satria": prefix = "MS"; break;
      case "Mustika Jaya": prefix = "MJ"; break;
      case "Pondok Melati": prefix = "PM"; break;
      case "Bantar Gebang": prefix = "BG"; break;
      case "Pondok Gede": prefix = "PG"; break;
      default: prefix = "LP";
    }
    try {
      final response = await _supabase.from('reports').select('id').eq('lokasi', daerahBaru);
      int nextNumber = response.length + 1;
      return "$prefix${nextNumber.toString().padLeft(3, '0')}";
    } catch (e) {
      return "${prefix}001";
    }
  }


  Future<void> submitReport({
    required String tanggal, required String lokasi, required String kategori, 
    required String deskripsi, required XFile imageFile,
  }) async {
    final user = _supabase.auth.currentUser;
    final userName = user?.userMetadata?['display_name'] ?? 'Warga Anonim';

    
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final imagePath = 'laporan/$fileName';
    final imageBytes = await imageFile.readAsBytes();

    await _supabase.storage.from('report_image').uploadBinary(
      imagePath, imageBytes, fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
    );
    final imageUrl = _supabase.storage.from('report_image').getPublicUrl(imagePath);

    String reportId = await generateNewReportId(lokasi);
    await _supabase.from('reports').insert({
      'report_id': reportId, 'user_id': user?.id, 'user_name': userName,
      'tanggal': tanggal, 'lokasi': lokasi, 'kategori': kategori,
      'deskripsi': deskripsi, 'image_url': imageUrl,
    });

   
    await _supabase.from('notifications').insert({
      'target_user': user?.id, 'title': 'Laporan Terkirim',
      'message': 'Laporan Anda ($reportId) berhasil dikirim dan masuk antrean.', 'icon_type': 'success'
    });
    await _supabase.from('notifications').insert({
      'target_user': 'PETUGAS', 'title': 'Laporan Baru Masuk',
      'message': 'Warga melaporkan kendala di $lokasi. Segera cek detailnya.', 'icon_type': 'alert',
    });
  }

 
  Future<void> updateReport({
    required dynamic reportDbId, required String currentReportStringId, required String currentLokasi,
    required String currentImageUrl, required String tanggal, required String lokasi,
    required String kategori, required String deskripsi, XFile? newImageFile,
  }) async {
    String imageUrl = currentImageUrl;
    if (newImageFile != null) {
      final fileExt = newImageFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final imagePath = 'laporan/$fileName';
      final imageBytes = await newImageFile.readAsBytes();

      await _supabase.storage.from('report_image').uploadBinary(imagePath, imageBytes, fileOptions: const FileOptions(upsert: false));
      imageUrl = _supabase.storage.from('report_image').getPublicUrl(imagePath);
    }

    String idLaporanFinal = currentReportStringId;
    if (lokasi != currentLokasi) idLaporanFinal = await generateNewReportId(lokasi);

    await _supabase.from('reports').update({
      'report_id': idLaporanFinal, 'tanggal': tanggal, 'lokasi': lokasi,
      'kategori': kategori, 'deskripsi': deskripsi, 'image_url': imageUrl,
    }).eq('id', reportDbId);
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String dob,
    required String phone,
    required String currentAvatarUrl,
    XFile? newProfileImage,
  }) async {
    String avatarUrlToSave = currentAvatarUrl;
    final user = _supabase.auth.currentUser;

    if (newProfileImage != null) {
      String fileExt = newProfileImage.name.split('.').last;
      if (fileExt.isEmpty || fileExt.length > 4) fileExt = 'png';

      final fileName = '${user!.id}.$fileExt';
      final imagePath = 'profiles/$fileName';
      final imageBytes = await newProfileImage.readAsBytes();

      await _supabase.storage.from('avatars').uploadBinary(
        imagePath, imageBytes, fileOptions: const FileOptions(upsert: true),
      );
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      avatarUrlToSave = "${_supabase.storage.from('avatars').getPublicUrl(imagePath)}?t=$timestamp";
    }

    String fullName = "$firstName $lastName".trim();

    await _supabase.auth.updateUser(
      UserAttributes(
        data: {
          'display_name': fullName,
          'dob': dob,
          'phone': phone,
          'avatar_url': avatarUrlToSave,
        },
      ),
    );

    await _supabase.from('notifications').insert({
      'target_user': user!.id,
      'title': 'Profil Diperbarui',
      'message': 'Perubahan data profil dan foto Anda telah berhasil disimpan.',
      'icon_type': 'success',
    });
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}