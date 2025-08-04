import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_colors.dart';
import '../../../core/core_widgets/back_header.dart';
import '../../model/repository/change_season_repository.dart';
import '../../view_model/cubit/change_season_cubit.dart';
import '../widgets/app_button.dart';
import '../widgets/app_input.dart';
import '../widgets/app_text.dart';
import 'change_season_otp.dart';

class ChangeSeason extends StatelessWidget {
  const ChangeSeason({super.key});
  static final TextEditingController emailController = TextEditingController();
  static final logger = Logger();

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
    final bottomSpacing = screenHeight / 6;
    return BlocProvider(
      create: (_) => ChangeSeasonCubit(ChangeSeasonRepository()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: BackHeader(),
            body: BlocListener<ChangeSeasonCubit, ChangeSeasonState>(
              listener: (context, state) {
                if (state is ChangeSeasonLoading) {
                  // Optionally show loading indicator
                } else if (state is ChangeSeasonSuccess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeSeasonOtp(
                        email: emailController.text,
                        loginData: {"email": emailController.text},
                      ),
                    ),
                  );
                } else if (state is ChangeSeasonFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(padding),
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
                        lbl: 'لا تستطيع تسجيل الدخول اذا تغيرت السنة الدراسي, جددها من هنا',
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
                      SizedBox(height: buttonSpacing),
                      AppButton(
                        lbl: 'تأكيد البريد الإلكتروني',
                        onPressed: () {
                          final email = emailController.text.trim();
                          final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('الرجاء إدخال بريدك الإلكتروني')),
                            );
                            return;
                          }
                          if (!emailRegExp.hasMatch(email)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('يرجى إدخال بريد إلكتروني صحيح')),
                            );
                            return;
                          }
                          context.read<ChangeSeasonCubit>().sendOtp(email);
                        },
                      ),
                      Spacer(),
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
