import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/services/report_service.dart';
import 'package:flutter/material.dart';

class PNotifikasi extends StatefulWidget {
  const PNotifikasi({super.key});

  @override
  State<PNotifikasi> createState() => _PNotifikasiState();
}

class _PNotifikasiState extends State<PNotifikasi> {
  List<Map<String, dynamic>> _notifList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

 
  Future<void> _fetchNotifications() async {
    try {
      final data = await ReportService().fetchPetugasNotifications();

      if (mounted) {
        setState(() {
          _notifList = data;
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
                color: AppColors.primaryPetugas,
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
        title: Text(
          'Notifikasi',
          style: AppTextStyles.h2Bold.copyWith(color: AppColors.primaryPetugas),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        color: AppColors.primaryPetugas,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryPetugas,
                ),
              )
            : _notifList.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Tidak ada notifikasi laporan baru.",
                      style: AppTextStyles.body.copyWith(color: Colors.grey),
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
    Color bgColor = AppColors.secondaryPetugas; 

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
                    style: AppTextStyles.title2Bold.copyWith(
                      color: AppColors.primaryPetugas,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notif['message'] ?? '',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryPetugas.withOpacity(0.8),
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
