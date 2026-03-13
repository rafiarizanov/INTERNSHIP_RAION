import 'package:INTERNSHIP_RAION/core/constants/app_colors.dart';
import 'package:INTERNSHIP_RAION/core/constants/app_text_styles.dart';
import 'package:INTERNSHIP_RAION/services/warga_service.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> _notifList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final data = await WargaService().fetchNotifications();
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.blueDarker,
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
        title: Text(
          'Notifikasi',
          style: AppTextStyles.h3Bold.copyWith(color: AppColors.blueDarker),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        color: AppColors.blueDarker,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notifList.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Belum ada notifikasi.",
                      style: AppTextStyles.title1.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
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
    IconData iconData = Icons.notifications;
    Color bgColor = AppColors.blueDark;

    if (notif['icon_type'] == 'success') {
      iconData = Icons.check_circle_outline;
      bgColor = Colors.green;
    } else if (notif['icon_type'] == 'chat') {
      iconData = Icons.chat_bubble_outline;
      bgColor = Colors.blue;
    } else if (notif['icon_type'] == 'info') {
      iconData = Icons.info_outline;
      bgColor = AppColors.blueDark;
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(iconData, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notif['title'] ?? '',
                  style: AppTextStyles.title2Bold.copyWith(
                    color: AppColors.blueDarker,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notif['message'] ?? '',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.blueGrey[700],
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
}
