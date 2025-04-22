import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/password_otp_screen.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const BackHeader(),
      body: BlocListener<StudentAuthCubit, StudentAuthState>(
        listener: (context, state) {
          if (state is StudentAuthLoading) {
            // Optionally show a loading indicator.
          } else if (state is StudentAuthSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PasswordOtp(email: emailController.text),
              ),
            );
          } else if (state is StudentAuthFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
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
                    lbl: 'إعادة تعيين كلمة المرور ',
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
                      'ادخل كلمة المرور القديمة و كلمة المرور الجديدة ليتم تغييرها',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                const AppText(
                  lbl: 'كلمة المرور القديم ',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.02),
                const AppInput(
                  // controller: emailController,
                  hintText: 'كلمة المرور القديم',
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.02),
                const AppText(
                  lbl: 'كلمة المرور الجديدة ',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.02),
                const AppInput(
                  // controller: emailController,
                  hintText: 'كلمة المرور الجديدة',
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.02),
                const AppText(
                  lbl: 'تأكيد كلمة المرور الجديدة ',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.02),
                const AppInput(
                  // controller: emailController,
                  hintText: 'كلمة المرور القديم',
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.04),
                AppButton(
                  lbl: ' إعادة تعيين كلمة المرور',
                  onPressed: () {
                   
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
