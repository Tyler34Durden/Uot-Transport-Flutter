import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/qr_scan_screen.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/change_season_cubit.dart';

import '../../model/repository/change_season_repository.dart';
import 'change_season_scan.dart';

class ChangeSeasonQr extends StatefulWidget {
  final Map<String, dynamic>? loginData;
  const ChangeSeasonQr({super.key, this.loginData});

  @override
  State<ChangeSeasonQr> createState() => _ChangeSeasonQrState();
}

class _ChangeSeasonQrState extends State<ChangeSeasonQr> {
  String? _qrCodeResult;
  final TextEditingController _registrationNumberController = TextEditingController();
  String? _selectedCollege;
  String? _selectedGender;
  final Map<String, String> genderMap = {'ذكر': 'male', 'أنثى': 'female'};

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final labelFontSize = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: BackHeader(
        onBackbtn: () => Navigator.pop(context),
      ),
      body: BlocProvider<ChangeSeasonCubit>(
        create: (_) => ChangeSeasonCubit(ChangeSeasonRepository()),
        child: BlocListener<ChangeSeasonCubit, ChangeSeasonState>(
          listener: (context, state) {
            if (state is ChangeSeasonSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث النموذج 2 بنجاح')),
              );
              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangeSeasonScan(),
                  ),
                );
              });
            } else if (state is ChangeSeasonFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: AppText(
                    lbl: 'مسح الرمز بالنموذج 2',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),
                AppText(
                  lbl: ' بريدك الإلكتروني',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: labelFontSize,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: screenHeight * 0.02),
                AppInput(
                  controller: TextEditingController(text: widget.loginData!['email']),
                  hintText: 'البريد الإلكتروني',
                  textAlign: TextAlign.right,
                  readOnly: true,
                ),
                SizedBox(height: screenHeight * 0.02),
                AppButton(
                  lbl: 'مسح الرمز بالنموذج 2',
                  icon: Icons.qr_code,
                  color: AppColors.secondaryColor,
                  textColor: AppColors.primaryColor,
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeSeasonScan(),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _qrCodeResult = result;
                      });
                    }
                  },
                ),
                // if (_qrCodeResult != null)
                //   AppText(
                //     lbl: 'نتيجة المسح: $_qrCodeResult',
                //     style: const TextStyle(
                //       color: AppColors.textColor,
                //       fontSize: 16,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                SizedBox(height: screenHeight * 0.01), // Reduced space
                AppText(
                  lbl: 'اين يمكنك إيجاد نموذج 2',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.right,
                  onTap: () {
                    // Handle additional navigation if needed.
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: AppButton(
          lbl: 'تحديث النموذج 2',
          onPressed: () {
            final updatedStudentData = {
              ...?widget.loginData,
              "qrData": _qrCodeResult,
              "otp": widget.loginData?['otp'], // Ensure otp is included
            };
            context.read<ChangeSeasonCubit>().updateSemester(updatedStudentData, context);
          },
        ),
      ),
    );
  }
}