import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PNotifikasi extends StatefulWidget {
  const PNotifikasi({super.key});

  @override
  State<PNotifikasi> createState() => _PNotifikasiState();
}

class _PNotifikasiState extends State<PNotifikasi> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _notifList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
     
      final data = await supabase
          .from('notifications')
          .select()
          .eq('target_user', 'PETUGAS')
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _notifList = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Center(
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF003D45),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF003D45),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        color: const Color(0xFF003D45),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notifList.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Tidak ada notifikasi laporan baru.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: _notifList.length,
                itemBuilder: (context, index) {
                  final notif = _notifList[index];
                  return _buildNotificationItem(notif);
                },
              ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notif) {
    IconData iconData = Icons.error_outline;
    Color bgColor = const Color(0xFF008394);

    if (notif['icon_type'] == 'alert') {
      iconData = Icons.warning_amber_rounded;
      bgColor = Colors.orange;
    } else if (notif['icon_type'] == 'chat') {
      iconData = Icons.chat_bubble_outline;
      bgColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
        ),
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(iconData, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003D45),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notif['message'] ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF006064),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
