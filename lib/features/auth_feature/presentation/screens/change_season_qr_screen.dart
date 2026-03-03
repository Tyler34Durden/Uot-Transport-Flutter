import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_update_request.dart';

import '../cubit/change_season_cubit.dart';
import '../cubit/change_season_state.dart';
import 'change_season_scan_screen.dart';

class ChangeSeasonQrScreen extends StatefulWidget {
  final Map<String, dynamic>? loginData;

  const ChangeSeasonQrScreen({super.key, this.loginData});

  @override
  State<ChangeSeasonQrScreen> createState() => _ChangeSeasonQrScreenState();
}

class _ChangeSeasonQrScreenState extends State<ChangeSeasonQrScreen> {
  String? _qrCodeResult;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final labelFontSize = screenWidth * 0.04;

    return BlocProvider<ChangeSeasonCubit>(
      create: (_) => getIt<ChangeSeasonCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: BackHeader(onBackbtn: () => Navigator.pop(context)),
        body: SafeArea(
          top: false,
          bottom: true,
          child: BlocListener<ChangeSeasonCubit, ChangeSeasonState>(
            listener: (context, state) {
              state.whenOrNull(
                success: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تحديث النموذج 2 بنجاح')),
                  );
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChangeSeasonScanScreen()),
                    );
                  });
                },
                failure: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.04,
                screenWidth * 0.04,
                screenWidth * 0.04,
                MediaQuery.of(context).padding.bottom + screenWidth * 0.04,
              ),
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
                    controller: TextEditingController(text: widget.loginData?['email']?.toString() ?? ''),
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
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.06,
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChangeSeasonScanScreen()),
                      );
                      if (result != null) {
                        setState(() {
                          _qrCodeResult = result.toString();
                        });
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.01),
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
                      // optional helper navigation
                    },
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  BlocBuilder<ChangeSeasonCubit, ChangeSeasonState>(
                    builder: (context, state) {
                      final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
                      return AppButton(
                        lbl: 'تحديث النموذج 2',
                        onPressed: isLoading
                            ? null
                            : () {
                                final email = widget.loginData?['email']?.toString() ?? '';
                                final otp = widget.loginData?['otp']?.toString() ?? '';
                                final qrData = (_qrCodeResult ?? '').toString();

                                context.read<ChangeSeasonCubit>().updateSemester(
                                  ChangeSeasonUpdateRequest(
                                    email: email,
                                    otp: otp,
                                    qrData: qrData,
                                  ),
                                );
                              },
                        color: AppColors.primaryColor,
                        textColor: AppColors.backgroundColor,
                        width: screenWidth * 0.7,
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
