import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/image_carousel.dart';
import 'package:uot_transport/auth_feature/view/widgets/uot_button.dart';
import 'package:uot_transport/core/app_colors.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Text("مرحبا بك في تطبيق\n نقل جامعة طرابلس!",style: TextStyle(
          //   fontSize: 28,
          //   fontWeight: FontWeight.bold,
          //   color: AppColors.primaryColor
          //
          // ),),
          // Text("طريقتك السهلة والموثوقة لإدارة رحلات\nالنقل الجامعي. كن متصلا, ووفر وقتك",
          // style: TextStyle(
          //   fontSize: 20,
          //   color: AppColors.primaryColor
          // )
          // ),
          ImageCarousel(),
          Spacer(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.064,
                child: UotButton(color: AppColors.primaryColor, textColor: AppColors.backgroundColor, text: 'إنشاء حساب',)),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.013,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.064,
                child: UotButton(color: AppColors.secondaryColor, textColor: AppColors.primaryColor, text: 'تسجيل دخول',)),
          ),
          Spacer(),],
      ),
    );
  }
}