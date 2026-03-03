import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/otp_request.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'login_screen.dart';

class VerifyScreen extends StatefulWidget {
  final String email;

  const VerifyScreen({super.key, required this.email});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
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
      // Use Builder to get a new context that is under BlocProvider.
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: const BackHeader(),
            body: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                state.whenOrNull(
                  verifyOtpSuccess: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
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
                      AppText(
                        textAlign: TextAlign.center,
                        lbl: 'تم إرسال رابط رمز مكون من ستة ارقام إلى ${widget.email}',
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 20,
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
                          if (otp.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('يرجى إدخال رمز التحقق')),
                            );
                            return;
                          }
                          blocContext.read<AuthCubit>().verifyOtp(
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
