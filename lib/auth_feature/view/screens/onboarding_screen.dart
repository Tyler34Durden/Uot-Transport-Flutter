import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/image_carousel.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ImageCarousel(),
          Text("مرحبا بك في تطبيق\n نقل جامعة طرابلس!"),
          Text("طريقتك السهلة والموثوقة لإدارة رحلات\nالنقل الجامعي. كن متصلا, ووفر وقتك"),
        ],
      ),
    );
  }
}