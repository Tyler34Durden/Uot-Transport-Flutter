import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/screens/confirm_study_status_screen.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_cubit.dart';
import 'package:uot_transport/auth_feature/model/repository/student_repository.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
                lbl: 'أنشئ حساباً جديداً واستمتع بتجربة نقل جامعي مريحة ومميزة.',
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
              AppInput(
                controller: fullNameController,
                hintText: 'الاسم الثلاثي ',
                textAlign: TextAlign.right,
                maxLength: 30,
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
              AppInput(
                controller: emailController,
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
              AppInput(
                controller: passwordController,
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
              AppInput(
                controller: confirmPasswordController,
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
                  final studentData = {
                    "fullName": fullNameController.text,
                    "uotNumber": "",
                    "userZone": "",
                    "qrData": "",
                    "email": emailController.text,
                    "password": passwordController.text,
                    "password_confirmation": confirmPasswordController.text,
                    "fcmToken": "temp_token",
                    "gender": ""
                  };
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfirmStudyStatusScreen(
                        studentData: studentData,
                        fullNameController: fullNameController,
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
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