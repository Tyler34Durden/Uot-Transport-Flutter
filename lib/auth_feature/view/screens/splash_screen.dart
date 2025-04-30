// import 'package:flutter/material.dart';
// import 'package:uot_transport/core/app_icons.dart';
// import 'package:uot_transport/core/app_colors.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // عرض الخلفية باستخدام Image.asset
//           Positioned.fill(
//             child: Image.asset(
//               AppIcons.background002,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Column(
//             children: [
//               const Spacer(flex: 3),
//               Center(
//                 child: Container(
//                   width: 275,
//                   height: 275,
//                   decoration: const BoxDecoration(
//                     color: AppColors.primaryColor, // اللون الأزرق للخلفية
//                     shape: BoxShape.circle,
//                   ),
//                   child: ClipOval(
//                     child: Image.asset(
//                       AppIcons.logo,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 80),
//               const Center(
//                 child: Text(
//                   'تنقل بسهولة... تعلم بثقة',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryColor,
//                   ),
//                 ),
//               ),
//               const Spacer(flex: 3),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/screens/onboarding_screen.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  _navigateToOnboarding() async {
    await Future.delayed(const Duration(seconds: 4), () {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Container(
          height: 275,
          width: 255,
          decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage(
            //     AppIcons.logoPath,
            //   ),
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
      ),
    );
  }
}
