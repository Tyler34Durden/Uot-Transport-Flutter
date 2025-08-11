//added after emeoved
import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/screens/onboarding_screen.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 4), () {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  OnBoardingScreen()),
            (route) => false, // This removes all previous routes
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Container(
          height: 275,
          width: 275,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppIcons.logo),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
