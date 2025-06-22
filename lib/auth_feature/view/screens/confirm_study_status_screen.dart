import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/screens/qr_scan_screen.dart';
import 'package:uot_transport/auth_feature/view/screens/verify_screen.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_dropdown.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';

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
  _ConfirmStudyStatusScreenState createState() =>
      _ConfirmStudyStatusScreenState();
}

class _ConfirmStudyStatusScreenState extends State<ConfirmStudyStatusScreen> {
  final TextEditingController _registrationNumberController =
      TextEditingController();
  String? _selectedCollege;
  String? _selectedGender;
  String? _qrCodeResult;

  @override
  void initState() {
    super.initState();
    _qrCodeResult = widget.studentData["qrData"];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: BackHeader(
        onBackbtn: () => Navigator.pop(context),
      ),
      body: BlocListener<StudentAuthCubit, StudentAuthState>(
        listener: (context, state) {
          if (state is StudentAuthLoading) {
            // Optionally show a loading indicator.
          } else if (state is RegisterStudentSuccess) {
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyScreen(
                    email: widget.studentData["email"],
                  ),
                ),
              );
            });
          } else if (state is StudentAuthFailure) {
            String errorMessage = 'حدث خطأ أثناء التسجيل.';
            final error = state.error;
            if (error is Map && error[0] != null) {
              errorMessage = error[0].toString();
            } else if (error is String) {
              errorMessage = error;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
        },
        child: SingleChildScrollView(
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
                    'كلية الهندسة',
                    'كلية تقنية المعلومات',
                    'كلية العلوم',
                    'كلية الآداب',
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
                  items: const ['female', 'male'],
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
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRScanScreen(
                            uotNumber: _registrationNumberController.text),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _qrCodeResult = result;
                      });
                    }
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
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
                SizedBox(height: screenHeight * 0.06),
                AppButton(
                  lbl: 'إنشاء حساب',
                  onPressed: () {
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
                      "uotNumber": _registrationNumberController.text,
                      "userZone": _selectedCollege,
                      "gender": _selectedGender,
                      "qrData": _qrCodeResult,
                    };
                    context.read<StudentAuthCubit>().registerStudent(updatedStudentData);
                  },
                ),
                SizedBox(height: screenHeight * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }
}