import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.lbl,
    required this.onPressed,
    this.height,
    this.width,
    this.icon,
    this.color,
    this.textColor,
    super.key,
  });

  final double? width;
  final double? height;
  final String? lbl;
  final Function()? onPressed;
  final IconData? icon;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 157,
      height: height ?? 57,
      decoration: BoxDecoration(
        color: color ?? AppColors.primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor ?? AppColors.accentColor,
              ),
              const SizedBox(width: 8),
            ],
            AppText(
              lbl: lbl,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor ?? AppColors.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}