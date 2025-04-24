import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import 'package:uot_transport/auth_feature/view/screens/login_screen.dart';
    import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
    import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
    import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
    import 'package:uot_transport/core/core_widgets/back_header.dart';
    import 'package:uot_transport/auth_feature/view/widgets/success_notification.dart';
    import 'package:uot_transport/core/app_colors.dart';
    import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
    import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';

    class NewPassword extends StatelessWidget {
      const NewPassword({super.key, required this.email, required this.otp});

      static final TextEditingController passwordController = TextEditingController();
      static final TextEditingController confirmPasswordController = TextEditingController();

      final String email;
      final String otp;

      @override
      Widget build(BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;

        return WillPopScope(
          onWillPop: () async {
            passwordController.clear();
            confirmPasswordController.clear();
            return true;
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: const BackHeader(),
            body: BlocListener<StudentAuthCubit, StudentAuthState>(
              listener: (context, state) {
                if (state is StudentAuthLoading) {
                  // Optionally show a loading indicator.
                } else if (state is ResetPasswordSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuccessNotification(
                        msg: 'تم تغيير كلمة المرور الخاصة بك بنجاح.انقر فوق متابعة لتسجيل الدخول',
                        nextRoute: LoginScreen(),
                      ),
                    ),
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
                        lbl: 'قم بإنشاء كلمة مرور جديدة.تأكد من انه يختلف عن كلمة المرور السابقة',
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
                      AppInput(
                        controller: passwordController,
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
                      AppInput(
                        controller: confirmPasswordController,
                        hintText: 'كلمة المرور',
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      AppButton(
                        lbl: ' تحديث كلمة المرور ',
                        onPressed: () {
                          final passwordData = {
                            "otp": otp,
                            "email": email,
                            "password": passwordController.text,
                            "password_confirmation": confirmPasswordController.text,
                          };
                          context.read<StudentAuthCubit>().resetPassword(passwordData);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }