import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/widgets/app_text.dart';

/// Simple success message banner.
class SuccessNotification extends StatelessWidget {
  const SuccessNotification({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha(20),
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText(
        lbl: message,
        style: const TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
