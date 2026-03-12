import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PDetailLaporan extends StatefulWidget {
  final Map<String, dynamic> report;
  const PDetailLaporan({super.key, required this.report});

  @override
  State<PDetailLaporan> createState() => _PDetailLaporanState();
}

class _PDetailLaporanState extends State<PDetailLaporan> {
  final supabase = Supabase.instance.client;
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
          selectedStatus = data['status'] ?? 'Belum Dibaca';
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
      final user = supabase.auth.currentUser;
      final metadata = user?.userMetadata;

     
      final userName = metadata?['display_name'] ?? 'Petugas DLH';
      final avatarUrl = metadata?['avatar_url'] ?? '';

      await supabase.from('report_comments').insert({
        'report_id': widget.report['id'],
        'user_name': userName,
        'avatar_url': avatarUrl,
        'role': 'Petugas',
        'message': msg,
      });
      await supabase.from('notifications').insert({
        'target_user': widget.report['user_id'],
        'title': 'Pesan dari Petugas',
        'message': 'Petugas menanggapi laporan Anda: "$msg"',
        'icon_type': 'chat',
      });
      await _fetchComments(); 
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim: $e')));
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
      await supabase.from('notifications').insert({
        'target_user':
            widget.report['user_id'], 
        'title': 'Status Laporan Berubah',
        'message':
            'Status laporan Anda (${widget.report['report_id']}) kini telah: $newStatus.',
        'icon_type': 'info',
      });
      await supabase
          .from('reports')
          .update({'status': newStatus})
          .eq('id', widget.report['id']);
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Status berhasil diperbarui!"),
            backgroundColor: Colors.green,
          ),
        );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memperbarui: $e"),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      setState(() => _isUpdating = false);
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
                  backgroundColor: Color(0xFF004D56),
                  child: Icon(Icons.support_agent, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Balas Laporan Warga",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D56),
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF004D56)),
                ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFF004D56)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _postComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D56),
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

  void _showFullScreenImage(String imageUrl) {
    if (imageUrl.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              minScale: 1.0,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
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
            decoration: BoxDecoration(
              color: const Color(0xFF004D56),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          "Detail Laporan",
          style: TextStyle(
            color: Color(0xFF004D56),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
         
          RefreshIndicator(
            onRefresh: _refreshData,
            color: const Color(0xFF004D56),
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), 
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "ID Laporan",
                          report['report_id'] ?? '-',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTextField(
                          "Kategori",
                          report['kategori'] ?? '-',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _showFullScreenImage(imageUrl),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xFF004D56)),
                            image: imageUrl.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: imageUrl.isEmpty
                              ? const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                        if (imageUrl.isNotEmpty)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.zoom_out_map,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    "Pelapor",
                    report['user_name'] ?? 'Warga Anonim',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField("Tanggal", report['tanggal'] ?? '-'),
                  const SizedBox(height: 20),
                  _buildTextField("Lokasi", report['lokasi'] ?? '-'),
                  const SizedBox(height: 20),
                  const Text(
                    "Deskripsi Masalah",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D56),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF004D56).withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      report['deskripsi'] ?? '-',
                      style: const TextStyle(
                        color: Color(0xFF004D56),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Status Laporan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D56),
                      fontSize: 16,
                    ),
                  ),
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

                 
                  const Text(
                    "Kolom Diskusi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D56),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _isLoadingChat
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF004D56),
                          ),
                        )
                      : _chatList.isEmpty
                      ? const Text(
                          "Belum ada diskusi pada laporan ini.",
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
                          backgroundColor: Color(0xFF004D56),
                          child: Icon(Icons.reply, color: Colors.white),
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
                                color: const Color(0xFF004D56).withOpacity(0.5),
                              ),
                            ),
                            child: const Text(
                              "Balas atau beri informasi ke warga...",
                              style: TextStyle(
                                color: Color(0xFF004D56),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ), 
                ],
              ),
            ),
          ),
          if (_isUpdating)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF004D56)),
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
              ? const Color(0xFF004D56).withOpacity(0.2)
              : Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: isPetugas
                ? const Color(0xFF004D56)
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
                            ? const Color(0xFF004D56)
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
                          color: const Color(0xFF004D56),
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

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF004D56),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF004D56).withOpacity(0.5)),
          ),
          child: Text(value, style: const TextStyle(color: Color(0xFF004D56))),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String dbStatus, String label) {
    bool isSelected =
        selectedStatus == dbStatus ||
        (selectedStatus == "Belum Dibaca" && label == "Dibaca");
    return GestureDetector(
      onTap: () => _updateStatus(dbStatus),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004D56) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF004D56).withOpacity(0.5)),
        ),
        alignment: Alignment.center,
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
}
