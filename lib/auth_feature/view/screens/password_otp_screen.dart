//added after removed
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/new_password_screen.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';
import 'package:flutter/services.dart';
class PasswordOtp extends StatefulWidget {
  final String email;
  const PasswordOtp({super.key, required this.email});

  @override
  State<PasswordOtp> createState() => _PasswordOtpState();
}

class _PasswordOtpState extends State<PasswordOtp> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: BackHeader(),
      body: BlocListener<StudentAuthCubit, StudentAuthState>(
        listener: (context, state) {
          if (state is ValidateOtpSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NewPassword(
                  email: widget.email,
                  otp: otpController.text,
                ),
              ),
            );
          } else if (state is StudentAuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
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
                  lbl: 'تم إرسال رمز مكون من ستة أرقام إلى ',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 5),
                AppText(
                  textAlign: TextAlign.center,
                  lbl: widget.email,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Arial', // LTR-friendly font for email
                  ),
                ),
                // RichText(
                //   textAlign: TextAlign.center,
                //   text: Text(
                //     style: TextStyle(
                //       color: AppColors.textColor,
                //       fontSize: 20,
                //       fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
                //     ),
                //     children: [
                //       const TextSpan(text: 'تم إرسال رمز مكون من ستة أرقام إلى '),
                //       TextSpan(
                //         text: widget.email,
                //         style: const TextStyle(
                //           fontWeight: FontWeight.bold,
                //           fontFamily: 'DMSans', // Use LTR-friendly font for email
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: screenHeight * 0.04),
                AppButton(
                  lbl: ' التحقق من الرمز',
                  onPressed: () {
                    final otp = otpController.text.trim();
                    if (otp.isEmpty || otp.length != 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('يرجى إدخال رمز تحقق مكون من 6 أرقام')),
                      );
                      return;
                    }
                    final otpData = {
                      "otp": otp,
                      "email": widget.email
                    };
                    context.read<StudentAuthCubit>().validateOtp(otpData);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}