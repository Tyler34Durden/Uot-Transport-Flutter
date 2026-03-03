import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_dropdown.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/auth_register_request.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'qr_scan_screen.dart';
import 'verify_screen.dart';

/// Clean-arch screen that keeps the legacy UI.
///
/// Note: the legacy version also scans QR using a separate screen.
/// For now we keep the same inputs, but QR scanning integration can be
/// re-added when the clean QR flow is migrated.
class ConfirmStudyStatusScreen extends StatefulWidget {
  final Map<String, dynamic> studentData;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const ConfirmStudyStatusScreen({
    super.key,
    required this.studentData,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<ConfirmStudyStatusScreen> createState() => _ConfirmStudyStatusScreenState();
}

class _ConfirmStudyStatusScreenState extends State<ConfirmStudyStatusScreen> {
  final TextEditingController _registrationNumberController =
      TextEditingController();

  String? _selectedCollege;
  String? _selectedGender;
  String? _qrCodeResult;

  final Map<String, String> genderMap = const {
    'ذكر': 'male',
    'أنثى': 'female',
  };

  @override
  void initState() {
    super.initState();
    _qrCodeResult = widget.studentData['qrData'];
  }

  @override
  void dispose() {
    _registrationNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: BackHeader(
          onBackbtn: () => Navigator.pop(context),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              registerSuccess: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VerifyScreen(email: widget.studentData['email'] as String),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: AppText(
                        lbl: 'تأكيد الحالة الدراسية',
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
                      lbl: 'ادخل بياناتك الدراسية ليتم التأكد منها',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    const AppText(
                      lbl: 'ادخل رقم قيدك',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    AppInput(
                      controller: _registrationNumberController,
                      hintText: 'رقم القيد',
                      textAlign: TextAlign.right,
                      maxLength: 10,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const AppText(
                      lbl: ' اختر كليتك ',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    AppDropdown(
                      items: const [
                        'كلية العلوم',
                        'كلية الهندسة',
                        'كلية الفنون',
                        'كلية الزراعة',
                        'كلية تقنية المعلومات',
                        'كلية الصيدلة',
                        'كلية الطب البشري',
                        'كلية الطب البيطري',
                        'كلية طب وجراحة الفم والأسنان',
                        'كلية التقنية الطبية',
                        'كلية الإقتصاد والعلوم السياسية',
                        'كلية التربية البدنية وعلوم الرياضة',
                        'كلية التربية/ قصر بن غشير',
                        'كلية التربية طرابلس',
                        'كلية التمريض',
                        'كلية التربية جنزور',
                        'كلية القانون',
                        'كلية العلوم الشرعية - تاجوراء',
                        'كلية العلوم الشرعية - سوق الجمعة',
                        'كلية الإقتصاد والادارة تاجوراء',
                        'المرحلة التمهيدية',
                        'كلية الإعلام',
                        'كلية الآداب واللغات',
                      ],
                      hintText: 'الكلية',
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCollege = newValue;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const AppText(
                      lbl: ' اختر الجنس ',
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    AppDropdown(
                      items: const ['ذكر', 'أنثى'],
                      hintText: 'الجنس',
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    AppButton(
                      lbl: ' مسح الرمز  بالنموذج 2 ',
                      icon: Icons.qr_code,
                      color: AppColors.secondaryColor,
                      textColor: AppColors.primaryColor,
                      onPressed: isLoading
                          ? null
                          : () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QRScanScreen(
                                    uotNumber: _registrationNumberController.text,
                                  ),
                                ),
                              );

                              if (!mounted) return;
                              if (result != null) {
                                setState(() {
                                  _qrCodeResult = result.toString();
                                });
                              }
                            },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    AppButton(
                      lbl: 'إنشاء حساب',
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_registrationNumberController.text.isEmpty ||
                                  _selectedCollege == null ||
                                  _selectedGender == null ||
                                  _qrCodeResult == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
                                );
                                return;
                              }

                              final updatedStudentData = {
                                ...widget.studentData,
                                'uotNumber': _registrationNumberController.text,
                                'userZone': _selectedCollege,
                                'gender': genderMap[_selectedGender],
                                'qrData': _qrCodeResult,
                              };

                              final request = AuthRegisterRequest(
                                fullName: (updatedStudentData['fullName'] as String?) ?? '',
                                email: (updatedStudentData['email'] as String?) ?? '',
                                password: (updatedStudentData['password'] as String?) ?? '',
                                passwordConfirmation:
                                    (updatedStudentData['password_confirmation'] as String?) ?? '',
                                uotNumber: (updatedStudentData['uotNumber'] as String?) ?? '',
                                userZone: (updatedStudentData['userZone'] as String?) ?? '',
                                gender: (updatedStudentData['gender'] as String?) ?? '',
                                qrData: (updatedStudentData['qrData'] as String?) ?? '',
                              );

                              context.read<AuthCubit>().register(request);
                              //context.read<AuthCubit>().register(request);
                            },
                    ),
                    SizedBox(height: screenHeight * 0.06),
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
