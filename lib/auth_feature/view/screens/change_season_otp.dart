import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/change_season_qr.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/change_season_cubit.dart';
import 'package:flutter/services.dart';
import 'package:uot_transport/auth_feature/model/repository/change_season_repository.dart';

class ChangeSeasonOtp extends StatelessWidget {
  final String email;
  final Map<String, dynamic>? loginData;

  const ChangeSeasonOtp({super.key, required this.email, this.loginData});

  static final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (_) => ChangeSeasonCubit(ChangeSeasonRepository()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: BackHeader(),
            body: BlocListener<ChangeSeasonCubit, ChangeSeasonState>(
              listener: (context, state) {
                if (state is ChangeSeasonSuccess) {
                  final updatedLoginData = Map<String, dynamic>.from(loginData ?? {});
                  updatedLoginData['otp'] = otpController.text.trim();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeSeasonQr(loginData: updatedLoginData),
                    ),
                  );
                } else if (state is ChangeSeasonFailure) {
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
                        lbl: 'تم إرسال رمز مكون من ستة ارقام إلى $email',
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
                          context.read<ChangeSeasonCubit>().validateOtp(email, otp);
                          // Navigation is handled in BlocListener below
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
