// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:uot_transport/auth_feature/view/screens/password_otp_screen.dart';
// // import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
// // import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
// // import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
// // import 'package:uot_transport/core/core_widgets/back_header.dart';
// // import 'package:uot_transport/core/app_colors.dart';
// // import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
// // import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';

// // class ChangePasswordScreen extends StatelessWidget {
// //   const ChangePasswordScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final screenHeight = MediaQuery.of(context).size.height;
// //     final TextEditingController emailController = TextEditingController();

// //     return Scaffold(
// //       backgroundColor: AppColors.backgroundColor,
// //       appBar: const BackHeader(),
// //       body: BlocListener<StudentAuthCubit, StudentAuthState>(
// //         listener: (context, state) {
// //           if (state is StudentAuthLoading) {
// //             // Optionally show a loading indicator.
// //           } else if (state is StudentAuthSuccess) {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(
// //                 builder: (context) => PasswordOtp(email: emailController.text),
// //               ),
// //             );
// //           } else if (state is StudentAuthFailure) {
// //             // Show error message
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               SnackBar(content: Text(state.error)),
// //             );
// //           }
// //         },
// //         child: SingleChildScrollView(
// //           child: Padding(
// //             padding: const EdgeInsets.all(16),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 SizedBox(height: screenHeight * 0.04),
// //                 const Center(
// //                   child: AppText(
// //                     lbl: 'إعادة تعيين كلمة المرور ',
// //                     style: TextStyle(
// //                       color: AppColors.primaryColor,
// //                       fontSize: 28,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(height: screenHeight * 0.02),
// //                 const AppText(
// //                   textAlign: TextAlign.center,
// //                   lbl:
// //                       'ادخل كلمة المرور القديمة و كلمة المرور الجديدة ليتم تغييرها',
// //                   style: TextStyle(
// //                     color: AppColors.textColor,
// //                     fontSize: 20,
// //                   ),
// //                 ),
// //                 SizedBox(height: screenHeight * 0.06),
// //                 const AppText(
// //                   lbl: 'كلمة المرور القديم ',
// //                   style: TextStyle(
// //                     color: AppColors.textColor,
// //                     fontSize: 14,
// //                   ),
// //                   textAlign: TextAlign.right,
// //                 ),
// //                 SizedBox(height: screenHeight * 0.02),
// //                 const AppInput(
// //                   // controller: emailController,
// //                   hintText: 'كلمة المرور القديم',
// //                   textAlign: TextAlign.right,
// //                 ),
// //                 SizedBox(height: screenHeight * 0.02),
// //                 const AppText(
// //                   lbl: 'كلمة المرور الجديدة ',
// //                   style: TextStyle(
// //                     color: AppColors.textColor,
// //                     fontSize: 14,
// //                   ),
// //                   textAlign: TextAlign.right,
// //                 ),
// //                 SizedBox(height: screenHeight * 0.02),
// //                 const AppInput(
// //                   // controller: emailController,
// //                   hintText: 'كلمة المرور الجديدة',
// //                   textAlign: TextAlign.right,
// //                 ),
// //                 SizedBox(height: screenHeight * 0.02),
// //                 const AppText(
// //                   lbl: 'تأكيد كلمة المرور الجديدة ',
// //                   style: TextStyle(
// //                     color: AppColors.textColor,
// //                     fontSize: 14,
// //                   ),
// //                   textAlign: TextAlign.right,
// //                 ),
// //                 SizedBox(height: screenHeight * 0.02),
// //                 const AppInput(
// //                   // controller: emailController,
// //                   hintText: 'كلمة المرور القديم',
// //                   textAlign: TextAlign.right,
// //                 ),
// //                 SizedBox(height: screenHeight * 0.04),
// //                 AppButton(
// //                   lbl: ' إعادة تعيين كلمة المرور',
// //                   onPressed: () {

// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
// import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
// import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
// import 'package:uot_transport/core/core_widgets/back_header.dart';
// import 'package:uot_transport/core/app_colors.dart';
// import 'package:uot_transport/profile_feature/view_model/cubit/profile_cubit.dart';
// import 'package:uot_transport/profile_feature/view_model/cubit/profile_state.dart';

// class ChangePasswordScreen extends StatelessWidget {
//   const ChangePasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final TextEditingController currentPasswordController = TextEditingController();
//     final TextEditingController newPasswordController = TextEditingController();
//     final TextEditingController confirmPasswordController = TextEditingController();

//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: const BackHeader(),
//       body: BlocListener<ProfileCubit, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileLoading) {
//             // يمكن عرض Loading indicator
//           } else if (state is ProfileSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('تم حفظ التغييرات.')),
//             );
//           } else if (state is ProfileFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.error)),
//             );
//           }
//         },
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: screenHeight * 0.04),
//                 const Center(
//                   child: AppText(
//                     lbl: 'إعادة تعيين كلمة المرور',
//                     style: TextStyle(
//                       color: AppColors.primaryColor,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 const AppText(
//                   textAlign: TextAlign.center,
//                   lbl: 'ادخل كلمة المرور القديمة و كلمة المرور الجديدة ليتم تغييرها',
//                   style: TextStyle(
//                     color: AppColors.textColor,
//                     fontSize: 20,
//                   ),
//                 ),
//                 SizedBox(height: screenHeight * 0.06),
//                 const AppText(
//                   lbl: 'كلمة المرور القديمة',
//                   style: TextStyle(
//                     color: AppColors.textColor,
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 AppInput(
//                   controller: currentPasswordController,
//                   hintText: 'أدخل كلمة المرور القديمة',
//                   textAlign: TextAlign.right,
//                   obscureText: true,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 const AppText(
//                   lbl: 'كلمة المرور الجديدة',
//                   style: TextStyle(
//                     color: AppColors.textColor,
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 AppInput(
//                   controller: newPasswordController,
//                   hintText: 'أدخل كلمة المرور الجديدة',
//                   textAlign: TextAlign.right,
//                   obscureText: true,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 const AppText(
//                   lbl: 'تأكيد كلمة المرور الجديدة',
//                   style: TextStyle(
//                     color: AppColors.textColor,
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//                 SizedBox(height: screenHeight * 0.02),
//                 AppInput(
//                   controller: confirmPasswordController,
//                   hintText: 'أعد إدخال كلمة المرور الجديدة',
//                   textAlign: TextAlign.right,
//                   obscureText: true,
//                 ),
//                 SizedBox(height: screenHeight * 0.04),
//                 AppButton(
//                   lbl: 'إعادة تعيين كلمة المرور',
//                   onPressed: () {
//                     if (newPasswordController.text != confirmPasswordController.text) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('كلمة المرور الجديدة غير متطابقة مع التأكيد')),
//                       );
//                       return;
//                     }
//                     // بناء جسم الطلب حسب API
//                     final passwordData = {
//                       "currentPassword": currentPasswordController.text,
//                       "password": newPasswordController.text,
//                       "password_confirmation": confirmPasswordController.text,
//                     };
//                     // استدعاء دالة تغيير كلمة المرور من ProfileCubit
//                     context.read<ProfileCubit>().changePassword("user_token_here", passwordData);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _token = '';

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token') ?? '';
    });
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('كلمة المرور الجديدة غير متطابقة مع التأكيد')),
      );
      return;
    }
    // تجهيز بيانات الطلب كما هو مطلوب من API
    final passwordData = {
      "currentPassword": _currentPasswordController.text.trim(),
      "password": _newPasswordController.text.trim(),
      "password_confirmation": _confirmPasswordController.text.trim(),
    };

    try {
      final response =
          await ApiService().putRequest('user', passwordData, token: _token);
      if (response.data != null && response.data['message'] != null) {
        // عرض رسالة نجاح من الخادم
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'])),
        );
      } else {
        throw Exception('بيانات الاستجابة غير صالحة');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تغيير كلمة المرور: ${e.toString()}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const BackHeader(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: screenHeight * 0.04),
              const Center(
                child: AppText(
                  lbl: 'إعادة تعيين كلمة المرور',
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
                lbl: 'ادخل كلمة المرور القديمة والجديدة لتغييرها',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
              const AppText(
                lbl: 'كلمة المرور القديمة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              AppInput(
                controller: _currentPasswordController,
                hintText: 'أدخل كلمة المرور القديمة',
                textAlign: TextAlign.right,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              const AppText(
                lbl: 'كلمة المرور الجديدة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              AppInput(
                controller: _newPasswordController,
                hintText: 'أدخل كلمة المرور الجديدة',
                textAlign: TextAlign.right,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              const AppText(
                lbl: 'تأكيد كلمة المرور الجديدة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              AppInput(
                controller: _confirmPasswordController,
                hintText: 'أعد إدخال كلمة المرور الجديدة',
                textAlign: TextAlign.right,
                obscureText: true,
              ),
              SizedBox(height: screenHeight * 0.04),
              AppButton(
                lbl: 'إعادة تعيين كلمة المرور',
                onPressed: _changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
