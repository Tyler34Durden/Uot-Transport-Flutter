import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_urls.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/main_screen.dart';
import 'package:uot_transport/core/permissions_helper.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'change_season_screen.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final logger = Logger();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.05;
    final titleFontSize = screenWidth * 0.07;
    final subtitleFontSize = screenWidth * 0.045;
    final labelFontSize = screenWidth * 0.04;
    final inputSpacing = screenHeight * 0.025;
    final buttonSpacing = screenHeight * 0.06;

    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          emailController.clear();
          passwordController.clear();
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 56,
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                state.whenOrNull(
                  loading: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Dialog(
                        backgroundColor: AppColors.backgroundColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.all(12),
                          child: Lottie.asset('assets/icons/DT_Loading.json'),
                        ),
                      ),
                    );
                  },
                  failure: (message) {
                    Navigator.of(context, rootNavigator: true)
                        .popUntil((route) => route is! PopupRoute);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(message)),
                    );
                  },
                  loginSuccess: (student) {
                    Navigator.of(context, rootNavigator: true)
                        .popUntil((route) => route is! PopupRoute);
                    emailController.clear();
                    passwordController.clear();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                      (route) => false,
                    );
                  },
                  seasonChangeRequired: () {
                    Navigator.of(context, rootNavigator: true)
                        .popUntil((route) => route is! PopupRoute);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChangeSeasonScreen()),
                    );
                  },
                );
              },
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: padding,
                      right: padding,
                      top: padding,
                      bottom: MediaQuery.of(context).padding.bottom + 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: AppText(
                            lbl: 'تسجيل الدخول',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: inputSpacing * 0.8),
                        AppText(
                          textAlign: TextAlign.center,
                          lbl: 'سجّل دخولك للوصول إلى خدمات النقل الجامعي بسهولة وراحة',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: subtitleFontSize,
                          ),
                        ),
                        SizedBox(height: inputSpacing * 1.5),
                        AppText(
                          lbl: 'ادخل بريدك الإلكتروني',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: labelFontSize,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: inputSpacing * 0.8),
                        AppInput(
                          suffixIcon: const Icon(Icons.email_rounded),
                          controller: emailController,
                          hintText: 'البريد الالكتروني',
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: inputSpacing * 1.5),
                        AppText(
                          lbl: 'ادخل كلمة مرورك ',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: labelFontSize,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: inputSpacing * 0.8),
                        AppInput(
                          suffixIcon: const Icon(Icons.lock_rounded),
                          onSuffixIconTap: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          prefixIcon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: AppColors.textColor,
                          ),
                          hintText: 'كلمة المرور',
                          textAlign: TextAlign.right,
                          obscureText: obscurePassword,
                          controller: passwordController,
                        ),
                        SizedBox(height: inputSpacing * 0.8),
                        AppText(
                          lbl: 'هل نسيت كلمة مرورك؟',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: labelFontSize,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.right,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: buttonSpacing),
                        AppButton(
                          lbl: 'تسجيل الدخول',
                          onPressed: () {
                            final email = emailController.text.trim();
                            final password = passwordController.text;

                            final emailRegExp =
                                RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

                            if (email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('الرجاء إدخال بريدك الإلكتروني')),
                              );
                              return;
                            }
                            if (!emailRegExp.hasMatch(email)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('يرجى إدخال بريد إلكتروني صحيح')),
                              );
                              return;
                            }
                            if (password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('الرجاء إدخال كلمة المرور')),
                              );
                              return;
                            }

                            context.read<AuthCubit>().login(
                              email: email,
                              password: password,
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.013),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              await PermissionsHelper.confirmAndOpenPrivacyPolicy(
                                  context, privacyPolicyUrl);
                            },
                            child: Text(
                              'سياسة الخصوصية',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.013),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignupScreen()),
                              );
                            },
                            child: Text(
                              'ليس لديك حساب؟ سجّل الآن',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
