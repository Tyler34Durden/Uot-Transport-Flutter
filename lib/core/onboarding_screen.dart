import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_urls.dart';
import 'package:uot_transport/core/permissions_helper.dart';

import 'package:uot_transport/features/auth_feature/presentation/screens/login_screen.dart' as clean_login;
import 'package:uot_transport/features/auth_feature/presentation/screens/signup_screen.dart' as clean_signup;
import 'package:uot_transport/features/auth_feature/presentation/widgets/image_carousel.dart';
import 'package:uot_transport/features/auth_feature/presentation/widgets/uot_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 56,
        ),
        body: Column(
          children: [
            const Spacer(),
            // Legacy UI used ImageCarousel() directly.
            // The clean widget requires `children`.
            const ImageCarousel(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.064,
                child: UotButton(
                  ontap: () async {
                    await _markOnboardingComplete();
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const clean_signup.SignupScreen()),
                    );
                  },
                  color: AppColors.primaryColor,
                  textColor: AppColors.backgroundColor,
                  text: 'إنشاء حساب',
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.013),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.064,
                child: UotButton(
                  ontap: () async {
                    await _markOnboardingComplete();
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const clean_login.LoginScreen()),
                    );
                  },
                  color: AppColors.secondaryColor,
                  textColor: AppColors.primaryColor,
                  text: 'تسجيل دخول',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () async {
                  await PermissionsHelper.confirmAndOpenPrivacyPolicy(
                    context,
                    privacyPolicyUrl,
                  );
                },
                child: const Text(
                  'سياسة الخصوصية',
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
  }
}
