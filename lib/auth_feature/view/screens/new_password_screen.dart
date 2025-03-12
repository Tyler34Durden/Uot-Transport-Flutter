import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/screens/login_screen.dart';
import 'package:uot_transport/auth_feature/view/screens/signup_screen.dart';
import 'package:uot_transport/auth_feature/view/screens/verify_screen.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/auth_feature/view/widgets/success_notification.dart';
import 'package:uot_transport/core/app_colors.dart';

class NewPassword extends StatelessWidget {
  const NewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const BackHeader(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: screenHeight * 0.04),
              const Center(
                child: AppText(
                  lbl: ' اختر كلمة مرور جديدة ',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const AppText(
                textAlign: TextAlign.center,
                lbl:
                    'قم بإنشاء كلمة مرور جديدة.تأكد من انه يختلف عن كلمة المرور السابقة',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              const AppText(
                lbl: 'ادخل كلمة مرورك',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: screenHeight * 0.02),
              const AppInput(
                hintText: 'كلمة المرور',
                textAlign: TextAlign.right,
              ),
              SizedBox(height: screenHeight * 0.04),
              const AppText(
                lbl: 'تأكيد كلمة المرور',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: screenHeight * 0.02),
              const AppInput(
                hintText: 'كلمة المرور',
                textAlign: TextAlign.right,
              ),
              SizedBox(height: screenHeight * 0.04),
              AppButton(
                lbl: ' تحديث كلمة المرور ',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuccessNotification(
                        msg:
                            'تم تغيير كلمة المرور الخاصة بك بنجاح.انقر فوق متابعة لتسجيل الدخول',
                        nextRoute: LoginScreen(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
