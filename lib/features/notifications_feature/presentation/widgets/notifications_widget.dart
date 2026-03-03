import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/widgets/app_text.dart';

class NotificationsWidget extends StatelessWidget {
  const NotificationsWidget({
    super.key,
    required this.notificationText,
    this.notificationBody,
    this.isRead = false,
  });

  final String notificationText;
  final String? notificationBody;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: isRead ? Colors.grey[200] : AppColors.backgroundColor,
          border: const Border(bottom: BorderSide(color: Colors.grey)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 5),
                const Icon(
                  Icons.notifications,
                  size: 24,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppText(
                    lbl: notificationText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            if (notificationBody != null && notificationBody!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 34.0),
                child: AppText(
                  lbl: notificationBody!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

