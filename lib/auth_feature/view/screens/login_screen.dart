import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/screens/forgot_password.dart';
import 'package:uot_transport/auth_feature/view/screens/signup_screen.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/auth_feature/view/widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: BackHeader(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: AppText(
                  lbl: 'تسجيل الدخول',
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
                lbl: 'سجّل دخولك للوصول إلى خدمات النقل الجامعي بسهولة وراحة',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
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
                hintText: 'البريد الالكتروني',
                textAlign: TextAlign.right,
              ),
              SizedBox(height: screenHeight * 0.04),
              const AppText(
                lbl: 'ادخل كلمة مرورك ',
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
              ),
              SizedBox(height: screenHeight * 0.02),
              AppText(
                lbl: 'هل نسيت كلمة مرورك؟',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14,
                  decoration: TextDecoration.underline, // Add underline
                ),
                textAlign: TextAlign.right,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPassword(),
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.06),
              AppButton(
                lbl: 'تسجيل الدخول',
         
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
              ),
        SizedBox(height: screenHeight/6,),
              AppText(
                lbl: 'ليس لديك حساب؟ انشىء حساب',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => const SignupScreen ()),
                 );
                },
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}