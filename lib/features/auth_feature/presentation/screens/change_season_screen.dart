import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';

import '../cubit/change_season_cubit.dart';
import '../cubit/change_season_state.dart';
import 'change_season_otp_screen.dart';

class ChangeSeasonScreen extends StatelessWidget {
  const ChangeSeasonScreen({super.key});

  static final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final padding = screenWidth * 0.05;
    final titleFontSize = screenWidth * 0.07;
    final subtitleFontSize = screenWidth * 0.045;
    final labelFontSize = screenWidth * 0.04;
    final inputSpacing = screenHeight * 0.025;
    final buttonHeight = screenHeight * 0.06;

    return BlocProvider<ChangeSeasonCubit>(
      create: (_) => getIt<ChangeSeasonCubit>(),
      child: BlocListener<ChangeSeasonCubit, ChangeSeasonState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeSeasonOtpScreen(
                    email: emailController.text.trim(),
                    loginData: {'email': emailController.text.trim()},
                  ),
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
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                padding,
                padding,
                padding,
                MediaQuery.of(context).padding.bottom + padding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: AppText(
                      lbl: 'تحديث السنة الدراسية',
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
                    lbl: 'لا تستطيع تسجيل الدخول اذا تغيرت السنة الدراسية, جددها من هنا',
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
                  SizedBox(height: inputSpacing * 2.0),
                  BlocBuilder<ChangeSeasonCubit, ChangeSeasonState>(
                    builder: (context, state) {
                      final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
                      return AppButton(
                        lbl: 'إرسال رمز التحقق',
                        onPressed: isLoading
                            ? null
                            : () {
                                final email = emailController.text.trim();
                                if (email.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('يرجى إدخال البريد الإلكتروني')),
                                  );
                                  return;
                                }
                                context.read<ChangeSeasonCubit>().sendOtp(email);
                              },
                        color: AppColors.primaryColor,
                        textColor: AppColors.backgroundColor,
                        width: double.infinity,
                        height: buttonHeight,
                      );
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

