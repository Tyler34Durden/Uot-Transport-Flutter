import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/features/auth_feature/presentation/cubit/auth_cubit.dart';
import 'package:uot_transport/features/auth_feature/presentation/cubit/auth_state.dart';
import 'password_otp_screen.dart' as password_otp;
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const BackHeader(),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              forgotPasswordSuccess: () {
                final email = emailController.text.trim();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => password_otp.PasswordOtpScreen(email: email),
                  ),
                );
              },
              failure: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
            );
          },
          builder: (context, state) {
            final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    const Center(
                      child: AppText(
                        lbl: 'إسترجاع كلمة المرور ',
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
                      lbl: 'دخل بياناتك ليتم إرسال اليك رمز تحقق لكي تعد تعيين كلمة مرورك',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.06),
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
                      suffixIcon: const Icon(Icons.email_rounded),
                      controller: emailController,
                      hintText: 'البريد الالكتروني',
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    AppButton(
                      lbl: ' إعادة تعيين كلمة المرور',
                      onPressed: isLoading
                          ? null
                          : () {
                              final email = emailController.text.trim();
                              final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('الرجاء إدخال بريدك الإلكتروني')),
                                );
                                return;
                              }
                              if (!emailRegExp.hasMatch(email)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('يرجى إدخال بريد إلكتروني صحيح')),
                                );
                                return;
                              }

                              context.read<AuthCubit>().forgotPassword(email);
                            },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
