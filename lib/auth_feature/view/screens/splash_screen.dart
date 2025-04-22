import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uot_transport/core/app_icons.dart';
import 'package:uot_transport/core/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              AppIcons.background,
            ),
          ),
          Column(
            children: [
              const Spacer(flex: 3),
              Center(
                child: SvgPicture.asset(
                  AppIcons.transport_logo,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'تنقل بسهولة... تعلم بثقة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ],
      ),
    );
  }
}