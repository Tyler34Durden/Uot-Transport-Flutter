import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primaryColor, // لون الخط
            width: 1.0, // عرض الخط
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 25,
        ),
        child: Row(
          children: [
            // أيقونة البحث
            IconButton(
              icon: const Icon(
                size: 30,
                Icons.search,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                // Handle search action
              },
            ),
            const SizedBox(width: 10),
            // أيقونة الإشعارات
            InkWell(
              onTap: () {
                // Handle notifications action
              },
              child: const Icon(
                size: 30,
                Icons.notifications_none_rounded,
                color: AppColors.primaryColor,
              ),
            ),
            const Spacer(),
            // الشعار
            SizedBox(
              child: Image.asset(
                'assets/images/logo-02-svg 1.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}