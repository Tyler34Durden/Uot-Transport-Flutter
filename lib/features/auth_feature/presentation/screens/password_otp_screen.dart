import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/features/auth_feature/presentation/cubit/auth_cubit.dart';
import 'package:uot_transport/features/auth_feature/presentation/cubit/auth_state.dart';
import 'new_password_screen.dart' as new_password;
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/otp_request.dart';

class PasswordOtpScreen extends StatefulWidget {
  final String email;
  const PasswordOtpScreen({super.key, required this.email});

  @override
  State<PasswordOtpScreen> createState() => _PasswordOtpScreenState();
}

class _PasswordOtpScreenState extends State<PasswordOtpScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
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
                  validateOtpSuccess: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new_password.NewPasswordScreen(
                          email: widget.email,
                          otp: otpController.text.trim(),
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
                      const AppText(
                        textAlign: TextAlign.center,
                        lbl: 'تم إرسال رمز مكون من ستة أرقام إلى ',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppText(
                        textAlign: TextAlign.center,
                        lbl: widget.email,
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Arial',
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      AppButton(
                        lbl: ' التحقق من الرمز',
                        onPressed: () {
                          final otp = otpController.text.trim();
                          if (otp.isEmpty || otp.length != 6) {
                            ScaffoldMessenger.of(innerContext).showSnackBar(
                              const SnackBar(content: Text('يرجى إدخال رمز تحقق مكون من 6 أرقام')),
                            );
                            return;
                          }
                          innerContext.read<AuthCubit>().validateOtp(
                            OtpRequest(
                              otp: otp,
                              email: widget.email,
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
