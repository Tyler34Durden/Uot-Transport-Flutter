import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_dropdown.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/auth_feature/view/widgets/header.dart';
import 'package:uot_transport/core/app_colors.dart';

class ConfirmStudyStatusScreen extends StatelessWidget {
  const ConfirmStudyStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: BackHeader(
          onBackbtn: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const AppInput(
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
                items: const ['كلية الهندسة', 'كلية الطب', 'كلية العلوم', 'كلية الآداب'],
                hintText: 'الكلية',
                onChanged: (String? newValue) {
                  // Handle change
                },
              ),
              SizedBox(height: screenHeight * 0.06),
              AppButton(
                lbl: ' مسح QR  نموذج 2 ',
                icon: Icons.qr_code,
                color: AppColors.secondaryColor,
                textColor: AppColors.primaryColor,
                onPressed: () {
                  // Handle the confirmation action
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              AppText(
                lbl: 'اين يمكنك إيجاد نموذج 2',
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline, // Add underline
                ),
                textAlign: TextAlign.right,
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const SignupScreen()),
                  // );
                },
              ),
              SizedBox(height: screenHeight/4.6,),
              AppButton(
                lbl: 'إنشاء حساب',
                onPressed: () {
                  // Handle the confirmation action
                },
              ),
              SizedBox(height: screenHeight * 0.06),
            ],
          ),
        ),
      ),
    );
  }
}
