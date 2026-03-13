import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/services/warga_service.dart';
import 'package:flutter/material.dart';
import 'w_edit_laporan.dart';

class W_DetailLaporan extends StatefulWidget {
  final Map<String, dynamic> report;
  const W_DetailLaporan({super.key, required this.report});

  @override
  State<W_DetailLaporan> createState() => _W_DetailLaporanState();
}

class _W_DetailLaporanState extends State<W_DetailLaporan> {
  bool _isLoading = false;
  bool _isLoadingChat = true;
  List<Map<String, dynamic>> _chatList = [];
  final TextEditingController _commentController = TextEditingController();
  String _currentStatus = 'Belum Dibaca';

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.report['status'] ?? 'Belum Dibaca';
    _fetchComments();
  }

  // 🌟 MEMANGGIL DARI SERVICE
  Future<void> _fetchComments() async {
    try {
      final data = await WargaService().fetchReportComments(
        widget.report['id'],
      );
      if (mounted) {
        setState(() {
          _chatList = data;
          _isLoadingChat = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingChat = false);
    }
  }

  Future<void> _refreshData() async {
    await _fetchComments();
    try {
      final statusStr = await WargaService().fetchSingleReportStatus(
        widget.report['id'],
      );
      if (mounted) setState(() => _currentStatus = statusStr);
    } catch (e) {
      debugPrint("Gagal refresh: $e");
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;
    final msg = _commentController.text.trim();
    _commentController.clear();
    Navigator.pop(context);

    setState(() => _isLoading = true);
    try {
      await WargaService().postWargaComment(
        reportDbId: widget.report['id'],
        reportStringId: widget.report['report_id'],
        message: msg,
      );
      await _fetchComments();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _hapusLaporan() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Laporan',
          style: AppTextStyles.title2Bold.copyWith(color: AppColors.blueDarker),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus laporan ini? Data tidak dapat dikembalikan.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await WargaService().deleteReport(widget.report['id']);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Laporan berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.blueDarker,
                  child: Icon(Icons.chat_bubble_outline, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  "Tulis Pesan",
                  style: AppTextStyles.h1Bold.copyWith(
                    color: AppColors.blueDarker,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.blueDarker),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Sampaikan informasi tambahan...",
                filled: true,
                fillColor: AppColors.blueLightActive.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: AppColors.blueDarker),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _postComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueDarker,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Kirim Pesan",
                  style: AppTextStyles.title1Bold.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusBgColor = AppColors.statusBelumDibacaBg;
    Color statusTextColor = AppColors.statusBelumDibacaText;

    if (_currentStatus == 'Laporan Dibaca') {
      statusBgColor = AppColors.statusDibacaBg;
      statusTextColor = AppColors.statusDibacaText;
    } else if (_currentStatus == 'Laporan Diproses') {
      statusBgColor = AppColors.statusDiprosesBg;
      statusTextColor = AppColors.statusDiprosesText;
    } else if (_currentStatus == 'Laporan Selesai') {
      statusBgColor = AppColors.statusSelesaiBg;
      statusTextColor = AppColors.statusSelesaiText;
    }

    bool canEditOrDelete = _currentStatus == 'Belum Dibaca';

    return Scaffold(
      backgroundColor: AppColors.bgWarga,
      appBar: AppBar(
        backgroundColor: AppColors.bgWarga,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blueDarker,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
        title: Text(
          'Detail Laporan',
          style: AppTextStyles.h1Bold.copyWith(color: AppColors.blueDarker),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.blueDarker),
            onSelected: (value) async {
              if (value == 'edit') {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => W_EditLaporan(report: widget.report),
                  ),
                );
                _refreshData();
              } else if (value == 'delete') {
                _hapusLaporan();
              }
            },
            itemBuilder: (BuildContext context) {
              if (!canEditOrDelete)
                return [
                  const PopupMenuItem(
                    value: 'disabled',
                    enabled: false,
                    child: Text(
                      'Tidak bisa diubah (Sudah diproses)',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ];
              return [
                const PopupMenuItem(value: 'edit', child: Text('Edit Laporan')),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    'Hapus Laporan',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            color: AppColors.blueDarker,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _currentStatus,
                      style: AppTextStyles.captionBold.copyWith(
                        color: statusTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Laporan ${widget.report['kategori']}",
                    style: AppTextStyles.h3Bold.copyWith(
                      color: AppColors.blueDarker,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    Icons.local_offer_outlined,
                    'Kategori',
                    widget.report['kategori'],
                  ),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    'Lokasi',
                    widget.report['lokasi'],
                  ),
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    'Tanggal',
                    widget.report['tanggal'],
                  ),
                  _buildInfoRow(
                    Icons.person_outline,
                    'Pelapor',
                    widget.report['user_name'] ?? 'Warga',
                  ),
                  _buildInfoRow(
                    Icons.tag,
                    'ID Laporan',
                    widget.report['report_id'],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Deskripsi Masalah',
                    style: AppTextStyles.title1Bold.copyWith(
                      color: AppColors.blueDarker,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      widget.report['deskripsi'] ?? '-',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.blueDark,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Foto Bukti',
                    style: AppTextStyles.title1Bold.copyWith(
                      color: AppColors.blueDarker,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (widget.report['image_url'] != null)
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullScreenImagePage(
                            imageUrl: widget.report['image_url'],
                          ),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              widget.report['image_url'],
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.zoom_out_map,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 25),
                  Text(
                    "Kolom Diskusi",
                    style: AppTextStyles.title2Bold.copyWith(
                      color: AppColors.blueDarker,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _isLoadingChat
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.blueDarker,
                          ),
                        )
                      : _chatList.isEmpty
                      ? const Text(
                          "Belum ada tanggapan atau instruksi dari petugas.",
                          style: TextStyle(color: Colors.grey),
                        )
                      : Column(
                          children: _chatList
                              .map((chat) => _buildChatBubble(chat))
                              .toList(),
                        ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: _showCommentSheet,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.blueDarker,
                          child: Icon(Icons.chat, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.blueLightActive.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.blueDarker.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              "Tanya atau balas pesan petugas...",
                              style: AppTextStyles.title1.copyWith(
                                color: AppColors.blueDarker,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.blueDarker),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> chat) {
    bool isPetugas = chat['role'] == 'Petugas';
    String userAvatar = chat['avatar_url'] ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isPetugas
            ? AppColors.blueLightActive.withOpacity(0.3)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isPetugas
              ? AppColors.blueDarker.withOpacity(0.2)
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isPetugas
                ? AppColors.blueDarker
                : Colors.grey.shade500,
            backgroundImage: userAvatar.isNotEmpty
                ? NetworkImage(userAvatar)
                : null,
            child: userAvatar.isEmpty
                ? Icon(
                    isPetugas ? Icons.support_agent : Icons.person,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chat['user_name'] ?? 'Anonim',
                      style: AppTextStyles.title1Bold.copyWith(
                        color: isPetugas
                            ? AppColors.blueDarker
                            : Colors.black87,
                      ),
                    ),
                    if (isPetugas)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blueDarker,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Petugas",
                          style: AppTextStyles.captionBold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  chat['message'] ?? '',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: AppTextStyles.title1.copyWith(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.title1Bold.copyWith(
                color: AppColors.blueDarker,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImagePage({super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
