import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';

class SuccessNotification extends StatelessWidget {
  const SuccessNotification({
    required this.msg,
    required this.nextRoute,
    this.imagePath = 'assets/images/success.svg',
    this.buttonLabel = 'متابعة',
    super.key,
  });

  final String? msg;
  final Widget nextRoute;
  final String imagePath;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // إضافة لون للخلفية
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // جعل النص في المنتصف
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 120, // تحديد العرض المطلوب للصورة
                    height: 120, // تحديد الارتفاع المطلوب للصورة
                    child: SvgPicture.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: AppText(
                    lbl: msg,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.primaryColor, // إضافة لون للخط
                    ),
                    textAlign: TextAlign.center, // جعل النص في المنتصف
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60, left: 16, right: 16), // إضافة padding للزر
            child: SizedBox(
              width: double.infinity, // جعل الزر بعرض الصفحة
              child: AppButton(
                lbl: buttonLabel,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => nextRoute,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}