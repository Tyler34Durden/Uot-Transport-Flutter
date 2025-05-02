//added after removed
import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/image_carousel.dart';
import 'package:uot_transport/auth_feature/view/widgets/uot_button.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/auth_feature/view/screens/signup_screen.dart';
import 'package:uot_transport/auth_feature/view/screens/login_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ImageCarousel(),
          Spacer(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.064,
              child: UotButton(
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupScreen ()),
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
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                color: AppColors.secondaryColor,
                textColor: AppColors.primaryColor,
                text: 'تسجيل دخول',
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}