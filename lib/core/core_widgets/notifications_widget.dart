import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';

class NotificationsWidget extends StatelessWidget {
  final String notificationText;
  final bool isRead;

  const NotificationsWidget({
    super.key,
    required this.notificationText,
    this.isRead = false,
  });

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
        child: Row(
          children: [
            const SizedBox(width: 5),
            SvgPicture.asset(
              'assets/icons/bus.svg',
              color: isRead ? Colors.grey : AppColors.primaryColor,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: AppText(
                lbl: notificationText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isRead ? Colors.grey : AppColors.textColor,
                ),
              ),
            ),
            // Blue circle for unread notifications
            AnimatedOpacity(
              opacity: isRead ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: isRead
                  ? const SizedBox(width: 22) // keep alignment
                  : Row(
                      children: [
                        const SizedBox(width: 10),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
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
