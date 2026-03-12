import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'w_edit_laporan.dart';

class W_DetailLaporan extends StatefulWidget {
  final Map<String, dynamic> report;
  const W_DetailLaporan({super.key, required this.report});

  @override
  State<W_DetailLaporan> createState() => _W_DetailLaporanState();
}

class _W_DetailLaporanState extends State<W_DetailLaporan> {
  final supabase = Supabase.instance.client;
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

 
  Future<void> _fetchComments() async {
    try {
      final data = await supabase
          .from('report_comments')
          .select()
          .eq('report_id', widget.report['id'])
          .order('created_at', ascending: true);
      if (mounted) {
        setState(() {
          _chatList = List<Map<String, dynamic>>.from(data);
          _isLoadingChat = false;
        });
      }
    } catch (e) {
      debugPrint("Gagal memuat chat: $e");
      if (mounted) setState(() => _isLoadingChat = false);
    }
  }

 
  Future<void> _refreshData() async {
    await _fetchComments();
    try {
     
      final data = await supabase
          .from('reports')
          .select('status')
          .eq('id', widget.report['id'])
          .single();
      if (mounted) {
        setState(() {
          _currentStatus = data['status'] ?? 'Belum Dibaca';
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

    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      final metadata = user?.userMetadata;

      final userName = metadata?['display_name'] ?? 'Warga';
      final avatarUrl = metadata?['avatar_url'] ?? '';

      await supabase.from('report_comments').insert({
        'report_id': widget.report['id'],
        'user_name': userName,
        'avatar_url': avatarUrl,
        'role': 'Warga',
        'message': msg,
      });
await supabase.from('notifications').insert({
  'target_user': 'PETUGAS', 
  'title': 'Balasan Warga',
  'message': 'Warga membalas pada laporan ${widget.report['report_id']}: "$msg"',
  'icon_type': 'chat'
});
      await _fetchComments();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                  backgroundColor: Color(0xFF003D4C),
                  child: Icon(Icons.chat_bubble_outline, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Tulis Pesan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003D4C),
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF003D4C)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Sampaikan informasi tambahan ke petugas...",
                filled: true,
                fillColor: const Color(0xFFE0F7FA).withOpacity(0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF003D4C)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _postComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003D4C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Kirim Pesan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _hapusLaporan() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Hapus Laporan',
          style: TextStyle(
            color: Color(0xFF003D4C),
            fontWeight: FontWeight.bold,
          ),
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
        await supabase.from('reports').delete().eq('id', widget.report['id']);
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

  @override
  Widget build(BuildContext context) {
    Color statusBgColor = Colors.grey.shade300;
    Color statusTextColor = Colors.grey.shade800;

    
    if (_currentStatus == 'Laporan Dibaca') {
      statusBgColor = const Color(0xFFBDE7F1);
      statusTextColor = const Color(0xFF00838F);
    } else if (_currentStatus == 'Laporan Diproses') {
      statusBgColor = const Color(0xFFFFF1AD);
      statusTextColor = const Color(0xFFB48A00);
    } else if (_currentStatus == 'Laporan Selesai') {
      statusBgColor = const Color(0xFFC8E6C9);
      statusTextColor = const Color(0xFF2E7D32);
    }

    bool canEditOrDelete = _currentStatus == 'Belum Dibaca';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF003D4C),
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
        title: const Text(
          'Detail Laporan',
          style: TextStyle(
            color: Color(0xFF003D4C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF003D4C)),
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
            color: const Color(0xFF003D4C),
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), 
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
                      style: TextStyle(
                        color: statusTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Laporan ${widget.report['kategori']}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003D4C),
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
                  const Text(
                    'Deskripsi Masalah',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003D4C),
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
                      style: const TextStyle(
                        color: Color(0xFF006064),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Foto Bukti',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003D4C),
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

                 
                  const Text(
                    "Kolom Diskusi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003D4C),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _isLoadingChat
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF003D4C),
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
                          backgroundColor: Color(0xFF003D4C),
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
                              color: const Color(0xFFE0F7FA),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFF003D4C).withOpacity(0.5),
                              ),
                            ),
                            child: const Text(
                              "Tanya atau balas pesan petugas...",
                              style: TextStyle(
                                color: Color(0xFF003D4C),
                                fontSize: 14,
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
                child: CircularProgressIndicator(color: Color(0xFF003D4C)),
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
        color: isPetugas ? const Color(0xFFE0F7FA) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isPetugas
              ? const Color(0xFF003D4C).withOpacity(0.2)
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isPetugas
                ? const Color(0xFF003D4C)
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPetugas
                            ? const Color(0xFF003D4C)
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
                          color: const Color(0xFF003D4C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Petugas",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  chat['message'] ?? '',
                  style: const TextStyle(
                    height: 1.4,
                    fontSize: 13,
                    color: Colors.black87,
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
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF003D4C),
                fontWeight: FontWeight.bold,
                fontSize: 13,
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
