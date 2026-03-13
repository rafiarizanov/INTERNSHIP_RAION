import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/providers/auth_provider.dart';
import 'package:INTERNSHIP_RAION/services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PDetailLaporan extends StatefulWidget {
  final Map<String, dynamic> report;
  const PDetailLaporan({super.key, required this.report});

  @override
  State<PDetailLaporan> createState() => _PDetailLaporanState();
}

class _PDetailLaporanState extends State<PDetailLaporan> {
  String selectedStatus = "Belum Dibaca";
  final TextEditingController _commentController = TextEditingController();

  bool _isUpdating = false;
  bool _isLoadingChat = true;
  List<Map<String, dynamic>> _chatList = [];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.report['status'] ?? 'Belum Dibaca';
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final data = await ReportService().fetchComments(widget.report['id']);
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
      final statusStr = await ReportService().fetchSingleReportStatus(widget.report['id']);
      if (mounted) {
        setState(() {
          selectedStatus = statusStr;
        });
      }
    } catch (e) {
      debugPrint("Gagal merefresh status: $e");
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final msg = _commentController.text.trim();
    _commentController.clear();
    Navigator.pop(context); 

    setState(() => _isUpdating = true);
    try {
      final authProv = Provider.of<AuthProvider>(context, listen: false);
      final userName = authProv.namaPetugas.isEmpty ? 'Petugas DLH' : authProv.namaPetugas;

      await ReportService().postPetugasComment(
        reportDbId: widget.report['id'],
        userIdPelapor: widget.report['user_id'],
        userName: userName,
        avatarUrl: '', 
        message: msg,
      );

      await _fetchComments(); 
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengirim: $e')));
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      selectedStatus = newStatus;
      _isUpdating = true;
    });

    try {
      await ReportService().updateReportStatus(
        reportDbId: widget.report['id'],
        reportStringId: widget.report['report_id'] ?? 'ID',
        userIdPelapor: widget.report['user_id'],
        newStatus: newStatus,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Status berhasil diperbarui!"), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memperbarui: $e"), backgroundColor: Colors.red));
      }
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundColor: AppColors.primaryPetugas, child: Icon(Icons.support_agent, color: Colors.white)),
                const SizedBox(width: 12),
                Text("Balas Laporan Warga", style: AppTextStyles.h1Bold.copyWith(color: AppColors.primaryPetugas)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: AppColors.primaryPetugas)),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Ketik tanggapan Anda...",
                filled: true,
                fillColor: const Color(0xFFE0F7FA).withOpacity(0.5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: AppColors.primaryPetugas)),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _postComment,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPetugas, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: Text("Kirim Pesan", style: AppTextStyles.title1Bold.copyWith(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    if (imageUrl.isEmpty) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(child: InteractiveViewer(clipBehavior: Clip.none, minScale: 1.0, maxScale: 4.0, child: Image.network(imageUrl, fit: BoxFit.contain, width: double.infinity, height: double.infinity))),
    )));
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final String imageUrl = report['image_url'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(color: AppColors.primaryPetugas, borderRadius: BorderRadius.circular(8)),
            child: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18), onPressed: () => Navigator.pop(context)),
          ),
        ),
        title: Text("Detail Laporan", style: AppTextStyles.h2Bold.copyWith(color: AppColors.primaryPetugas)),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            color: AppColors.primaryPetugas,
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), 
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildTextField("ID Laporan", report['report_id'] ?? '-')),
                      const SizedBox(width: 15),
                      Expanded(child: _buildTextField("Kategori", report['kategori'] ?? '-')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _showFullScreenImage(imageUrl),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 200, width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.primaryPetugas),
                            image: imageUrl.isNotEmpty ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
                          ),
                          child: imageUrl.isEmpty ? const Icon(Icons.image, size: 50, color: Colors.grey) : null,
                        ),
                        if (imageUrl.isNotEmpty) Positioned(top: 10, right: 10, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle), child: const Icon(Icons.zoom_out_map, color: Colors.white, size: 18))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField("Pelapor", report['user_name'] ?? 'Warga Anonim'),
                  const SizedBox(height: 20),
                  _buildTextField("Tanggal", report['tanggal'] ?? '-'),
                  const SizedBox(height: 20),
                  _buildTextField("Lokasi", report['lokasi'] ?? '-'),
                  const SizedBox(height: 20),
                  Text("Deskripsi Masalah", style: AppTextStyles.title2Bold.copyWith(color: AppColors.primaryPetugas)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryPetugas.withOpacity(0.5))),
                    child: Text(report['deskripsi'] ?? '-', style: AppTextStyles.title1.copyWith(color: AppColors.primaryPetugas, height: 1.4)),
                  ),
                  const SizedBox(height: 20),

                  Text("Status Laporan", style: AppTextStyles.title2Bold.copyWith(color: AppColors.primaryPetugas)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusButton("Laporan Dibaca", "Dibaca"),
                      _buildStatusButton("Laporan Diproses", "Diproses"),
                      _buildStatusButton("Laporan Selesai", "Selesai"),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Text("Kolom Diskusi", style: AppTextStyles.title2Bold.copyWith(color: AppColors.primaryPetugas)),
                  const SizedBox(height: 12),
                  _isLoadingChat
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPetugas))
                      : _chatList.isEmpty
                      ? Text("Belum ada diskusi pada laporan ini.", style: AppTextStyles.body.copyWith(color: Colors.grey))
                      : Column(children: _chatList.map((chat) => _buildChatBubble(chat)).toList()),

                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: _showCommentSheet,
                    child: Row(
                      children: [
                        const CircleAvatar(backgroundColor: AppColors.primaryPetugas, child: Icon(Icons.reply, color: Colors.white)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                            decoration: BoxDecoration(color: const Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(30), border: Border.all(color: AppColors.primaryPetugas.withOpacity(0.5))),
                            child: Text("Balas atau beri informasi ke warga...", style: AppTextStyles.title1.copyWith(color: AppColors.primaryPetugas)),
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
          if (_isUpdating) Container(color: Colors.black.withOpacity(0.3), child: const Center(child: CircularProgressIndicator(color: AppColors.primaryPetugas))),
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
        color: isPetugas ? const Color(0xFFE0F7FA) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isPetugas ? AppColors.primaryPetugas.withOpacity(0.2) : Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isPetugas ? AppColors.primaryPetugas : Colors.grey.shade500,
            backgroundImage: userAvatar.isNotEmpty ? NetworkImage(userAvatar) : null,
            child: userAvatar.isEmpty ? Icon(isPetugas ? Icons.support_agent : Icons.person, color: Colors.white, size: 20) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(chat['user_name'] ?? 'Anonim', style: AppTextStyles.title1Bold.copyWith(color: isPetugas ? AppColors.primaryPetugas : Colors.black87)),
                    if (isPetugas)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primaryPetugas, borderRadius: BorderRadius.circular(10)),
                        child: Text("Petugas", style: AppTextStyles.captionBold.copyWith(color: Colors.white)),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(chat['message'] ?? '', style: AppTextStyles.body.copyWith(color: Colors.black87, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.title2Bold.copyWith(color: AppColors.primaryPetugas)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primaryPetugas.withOpacity(0.5))),
          child: Text(value, style: AppTextStyles.title2.copyWith(color: AppColors.primaryPetugas)),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String dbStatus, String label) {
    bool isSelected = selectedStatus == dbStatus || (selectedStatus == "Belum Dibaca" && label == "Dibaca");
    return GestureDetector(
      onTap: () => _updateStatus(dbStatus),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPetugas : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryPetugas.withOpacity(0.5)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.title1Bold.copyWith(color: isSelected ? Colors.white : AppColors.primaryPetugas),
        ),
      ),
    );
  }
}