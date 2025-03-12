import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/screens/confirm_study_status_screen.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: BackHeader(
        onBackbtn: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: AppText(
                  lbl: 'إنشاء حساب ',
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
                lbl:'أنشئ حساباً جديداً واستمتع بتجربة نقل جامعي مريحة ومميزة.',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              const AppText(
                lbl: 'ادخل اسمك الثلاثي  ',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: screenHeight * 0.02),
              const AppInput(
                hintText: 'الاسم الثلاثي ',
                textAlign: TextAlign.right,
                maxLength: 10,
              ),
              SizedBox(height: screenHeight * 0.02),
              const AppText(
                lbl: 'ادخل بريدك الإلكتروني',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: screenHeight * 0.02),
              const AppInput(
                hintText: 'البريد الإلكتروني ',
                textAlign: TextAlign.right,
                maxLength: 40,
              ),

              SizedBox(height: screenHeight * 0.02),
              const AppText(
                lbl: 'ادخل كلمة مرورك  ',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: screenHeight * 0.02),
              const AppInput(
                hintText: 'كلمة المرور  ',
                textAlign: TextAlign.right,
                maxLength: 25,
              ),

              SizedBox(height: screenHeight * 0.02),
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
                hintText: 'كلمة المرور ',
                textAlign: TextAlign.right,
                maxLength: 25,
              ),
              SizedBox(height: screenHeight * 0.06),
              AppButton(
                lbl: 'التالي ',
                width: screenWidth * 0.4,
                height: screenHeight * 0.07,
                onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ConfirmStudyStatusScreen ()),
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