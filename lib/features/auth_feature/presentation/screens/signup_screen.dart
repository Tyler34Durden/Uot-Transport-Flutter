import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';
import 'package:uot_transport/features/auth_feature/presentation/screens/confirm_study_status_screen.dart'
    as confirm;

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

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

    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) return;
          fullNameController.clear();
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: BackHeader(
            onBackbtn: () {
              Navigator.pop(context);
            },
          ),
          body: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              state.whenOrNull(
                failure: (message) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
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
                        lbl:
                            'أنشئ حساباً جديداً واستمتع بتجربة نقل جامعي مريحة ومميزة.',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      const AppText(
                        lbl: 'اسمك الثلاثي  ',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      AppInput(
                        suffixIcon: const Icon(Icons.person_rounded),
                        controller: fullNameController,
                        hintText: 'ادخل الاسم الثلاثي ',
                        textAlign: TextAlign.right,
                        maxLength: 30,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const AppText(
                        lbl: 'بريدك الإلكتروني',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      AppInput(
                        suffixIcon: const Icon(Icons.email_rounded),
                        controller: emailController,
                        hintText: 'ادخل البريد الإلكتروني ',
                        textAlign: TextAlign.right,
                        maxLength: 40,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const AppText(
                        lbl: 'كلمة المرور  ',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      AppInput(
                        suffixIcon: const Icon(Icons.lock_open_rounded),
                        prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: AppColors.textColor,
                          ),
                        ),
                        obscureText: obscurePassword,
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
                        suffixIcon: const Icon(Icons.lock_open_rounded),
                        prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: AppColors.textColor,
                          ),
                        ),
                        obscureText: obscureConfirmPassword,
                        controller: confirmPasswordController,
                        hintText: 'ادخل كلمة المرور (تأكيد)',
                        textAlign: TextAlign.right,
                        maxLength: 25,
                      ),
                      SizedBox(height: screenHeight * 0.06),
                      AppButton(
                        lbl: 'التالي ',
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.07,
                        onPressed: () {
                          final fullName = fullNameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text;
                          final confirmPassword =
                              confirmPasswordController.text;

                          final nameRegExp =
                              RegExp(r'^[\p{L} ]+$', unicode: true);
                          final emailRegExp =
                              RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                          final passwordRegExp = RegExp(
                              r"""^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$])[A-Za-z\d@#$]{8,}$""");

                          if (fullName.isEmpty) {
                            _showError(context, 'الرجاء إدخال اسمك الثلاثي');
                            return;
                          }
                          if (!nameRegExp.hasMatch(fullName)) {
                            _showError(context, 'يجب أن يحتوي الاسم على أحرف فقط');
                            return;
                          }
                          if (email.isEmpty) {
                            _showError(context, 'الرجاء إدخال بريدك الإلكتروني');
                            return;
                          }
                          if (!emailRegExp.hasMatch(email)) {
                            _showError(context, 'يرجى إدخال بريد إلكتروني صحيح');
                            return;
                          }
                          if (password.isEmpty) {
                            _showError(context, 'الرجاء إدخال كلمة المرور');
                            return;
                          }
                          if (!passwordRegExp.hasMatch(password)) {
                            _showError(
                              context,
                              'يجب أن تتكوّن كلمة المرور من 8 أحرف على الأقل، وتشمل أحرفًا كبيرة وصغيرة، أرقامًا، ورموزًا خاصة مثل (@، #، \$).',
                            );
                            return;
                          }
                          if (password != confirmPassword) {
                            _showError(
                                context, 'كلمة المرور وتأكيد كلمة المرور غير متطابقتين');
                            return;
                          }

                          final studentData = {
                            'fullName': fullName,
                            'email': email,
                            'password': password,
                            'password_confirmation': confirmPassword,
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => confirm.ConfirmStudyStatusScreen(
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
            ),
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
