import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';

import '../cubit/change_season_cubit.dart';
import '../cubit/change_season_state.dart';

import 'change_season_qr_screen.dart';

class ChangeSeasonOtpScreen extends StatelessWidget {
  final String email;
  final Map<String, dynamic>? loginData;

  const ChangeSeasonOtpScreen({super.key, required this.email, this.loginData});

  static final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider<ChangeSeasonCubit>(
      create: (_) => getIt<ChangeSeasonCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const BackHeader(),
        body: SafeArea(
          top: false,
          bottom: true,
          child: BlocListener<ChangeSeasonCubit, ChangeSeasonState>(
            listener: (context, state) {
              state.whenOrNull(
                success: () {
                  final updatedLoginData = Map<String, dynamic>.from(loginData ?? {});
                  updatedLoginData['otp'] = otpController.text.trim();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeSeasonQrScreen(loginData: updatedLoginData),
                    ),
                  );
                },
                failure: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $message')),
                  );
                },
              );
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 24,
                top: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.04),
                  Center(
                    child: Text(
                      'التحقق',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
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
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  BlocBuilder<ChangeSeasonCubit, ChangeSeasonState>(
                    builder: (context, state) {
                      final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
                      return AppButton(
                        lbl: ' التحقق من الرمز',
                        onPressed: isLoading
                            ? null
                            : () {
                                final otp = otpController.text.trim();
                                if (otp.isEmpty || otp.length != 6) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('يرجى إدخال رمز تحقق مكون من 6 أرقام')),
                                  );
                                  return;
                                }

                                context
                                    .read<ChangeSeasonCubit>()
                                    .validateOtp(email: email, otp: otp);
                              },
                        color: AppColors.primaryColor,
                        textColor: AppColors.backgroundColor,
                        width: double.infinity,
                        height: screenHeight * 0.06,
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
