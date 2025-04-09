import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/profile_feature/view/widgets/profile_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // تعديل المحاذاة بحيث يكون المحتوى بمحاذاة اليمين
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: ProfileImageWidget(
                imageUrl: 'https://example.com/profile.jpg',
                onEdit: () {
                  // هنا يمكنك تنفيذ عملية التعديل
                  debugPrint('Edit icon tapped');
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppText(
                    lbl: 'الإسم التاثي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    lbl: 'محي الدين محمود عقيلة',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    lbl: 'البريد الإلكتروني',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    lbl: 'uottransport@uot.edu.eg',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    lbl: 'الكلية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    lbl: 'كلية تقنية المعلومات',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AppText(
                    lbl: 'رقم الهاتف',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AppInput(
                    hintText: 'رقم الهاتف',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppButton(lbl: 'حفظ التغييرات', onPressed: () {}),
                  const SizedBox(height: 10),
                  AppButton(
                    lbl: 'تسجيل خروج',
                    color: AppColors.secondaryColor,
                    textColor: AppColors.primaryColor,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  const AppText(
                    lbl:
                        ' *في حالة الرغبة في تغيير اي من الإسم او البريد الإلكتروني  او الكلية الرجاء التواصل معا إدارة النقل الطلابي ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
