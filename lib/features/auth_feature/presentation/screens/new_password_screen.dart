import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/features/auth_feature/presentation/cubit/auth_cubit.dart';
import 'package:uot_transport/features/auth_feature/presentation/cubit/auth_state.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';
import 'login_screen.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/reset_password_request.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.email, required this.otp});

  final String email;
  final String otp;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: const BackHeader(),
            body: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                state.whenOrNull(
                  resetPasswordSuccess: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
                    );
                  },
                  failure: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  },
                );
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
                        lbl: 'قم بإنشاء كلمة مرور جديدة. تأكد من أنها تختلف عن كلمة المرور السابقة',
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
                          innerContext.read<AuthCubit>().resetPassword(
                                ResetPasswordRequest(
                                  otp: widget.otp,
                                  email: widget.email,
                                  password: passwordController.text,
                                  passwordConfirmation: confirmPasswordController.text,
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
