//added after removed
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';

class NotificationsWidget extends StatelessWidget {
  final String notificationText;

  const NotificationsWidget({
    super.key,
    required this.notificationText,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          border: const Border(bottom: BorderSide(color: Colors.grey)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(width: 5),
            SvgPicture.asset('assets/icons/bus.svg'),
            const SizedBox(width: 20),
            Expanded(
              child: AppText(
                lbl: notificationText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
