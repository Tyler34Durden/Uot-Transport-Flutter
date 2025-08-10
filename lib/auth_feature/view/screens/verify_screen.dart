//added after removed
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/login_screen.dart';
import 'package:uot_transport/auth_feature/view/screens/new_password_screen.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';

class VerifyScreen extends StatelessWidget {
  final String email;

  const VerifyScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController otpController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: BackHeader(),
      body: BlocListener<StudentAuthCubit, StudentAuthState>(
        listener: (context, state) {
          if (state is StudentAuthLoading) {
            // Optionally show a loading indicator.
          } else if (state is VerifyOtpSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false, // Removes all previous routes
            );
          } else if (state is StudentAuthFailure) {
            print('Error: ${state.error}');
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.04),
                const Center(
                  child: AppText(
                    lbl: 'تحقق من بريدك  ',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                AppText(
                  textAlign: TextAlign.center,
                  lbl: 'تم إرسال رابط رمز مكون من ستة ارقام إلى $email',
                  style: const TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                const AppText(
                  lbl: 'ادخل رمز التحقق',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.02),
                AppInput(
                  controller: otpController,
                  hintText: 'رمز التحقق',
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.04),
                AppButton(
                  lbl: ' التحقق من الرمز',
                  onPressed: () {
                    final otpData = {
                      "otp": int.parse(otpController.text),
                      "email": email
                    };
                    context.read<StudentAuthCubit>().verifyOtp(otpData);
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                AppText(
                  lbl: 'لم تحصل على رمز بعد؟ إعادة إرسال البريد الإلكتروني',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  onTap: () {
                    // Handle resend OTP
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}