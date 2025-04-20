// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
// import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
// import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
// import 'package:uot_transport/core/app_colors.dart';
// import 'package:uot_transport/profile_feature/view/widgets/profile_image.dart';
// import 'package:uot_transport/profile_feature/view_model/cubit/profile_cubit.dart';
// import 'package:uot_transport/profile_feature/view_model/cubit/profile_state.dart';

// class ProfileScreen extends StatefulWidget {
//   final String token;
//   final int userId;

//   const ProfileScreen({super.key, required this.token, required this.userId});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context
//           .read<ProfileCubit>()
//           .fetchUserProfile(widget.token, widget.userId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: BlocBuilder<ProfileCubit, ProfileState>(
//           builder: (context, state) {
//             if (state is ProfileLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is ProfileFailure) {
//               return Center(child: Text('Error: ${state.error}'));
//             } else if (state is ProfileSuccess) {
//               final profile = state.profile;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   Center(
//                     child: ProfileImageWidget(
//                       imageUrl: profile['profilePhoto'] ?? '',
//                       onEdit: () {
//                         debugPrint('Edit icon tapped');
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.all(26),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         const AppText(
//                           lbl: 'الإسم الثلاثي',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         AppText(
//                           lbl: profile['fullName'] ?? '',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 10),
//                         const AppText(
//                           lbl: 'البريد الإلكتروني',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         AppText(
//                           lbl: profile['email'] ?? '',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 10),
//                         const AppText(
//                           lbl: 'الكلية',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         AppText(
//                           lbl: profile['userZone'],
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 10),
//                         const AppText(
//                           lbl: 'رقم الهاتف',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         AppInput(
//                           hintText: profile['phone'] ?? '',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         const SizedBox(height: 10),
//                         AppButton(lbl: 'حفظ التغييرات', onPressed: () {}),
//                         const SizedBox(height: 10),
//                         AppButton(
//                           lbl: 'تسجيل خروج',
//                           color: AppColors.secondaryColor,
//                           textColor: AppColors.primaryColor,
//                           onPressed: () {},
//                         ),
//                         const SizedBox(height: 20),
//                         const AppText(
//                           lbl:
//                               ' *في حالة الرغبة في تغيير اي من الإسم او البريد الإلكتروني او الكلية الرجاء التواصل معا إدارة النقل الطلابي ',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/profile_feature/view/widgets/profile_image.dart';
import 'package:uot_transport/profile_feature/view_model/cubit/profile_cubit.dart';
import 'package:uot_transport/profile_feature/view_model/cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  final String token;
  final int userId;

  const ProfileScreen({super.key, required this.token, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ProfileCubit>()
          .fetchUserProfile(widget.token, widget.userId);
    });
  }

  void _saveChanges(Map<String, dynamic> currentProfile) {
    final updatedData = {
      'name': currentProfile['fullName'] ?? '',
      'userZone': currentProfile['userZone'] ?? '',
      'role': currentProfile['role'] ?? 'student',
      'phone': _phoneController.text.trim(),
    };

    context
        .read<ProfileCubit>()
        .updateUserProfile(widget.token, widget.userId, updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileFailure) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is ProfileSuccess) {
              final profile = state.profile;
              _phoneController.text = profile['phone'] ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: ProfileImageWidget(
                      imageUrl: profile['profilePhoto'] ?? '',
                      onEdit: () {
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
                          lbl: 'الإسم الثلاثي',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppText(
                          lbl: profile['fullName'] ?? '',
                          style: const TextStyle(fontSize: 16),
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
                        AppText(
                          lbl: profile['email'] ?? '',
                          style: const TextStyle(fontSize: 16),
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
                        AppText(
                          lbl: profile['userZone'] ?? 'كلية تقنية المعلومات',
                          style: const TextStyle(fontSize: 16),
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
                        AppInput(
                          controller: _phoneController,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        AppButton(
                          lbl: 'حفظ التغييرات',
                          onPressed: () => _saveChanges(profile),
                        ),
                        const SizedBox(height: 10),
                        AppButton(
                          lbl: 'تسجيل خروج',
                          color: AppColors.secondaryColor,
                          textColor: AppColors.primaryColor,
                          onPressed: () {
                            // تنفيذ منطق تسجيل الخروج
                          },
                        ),
                        const SizedBox(height: 20),
                        const AppText(
                          lbl:
                              ' *في حالة الرغبة في تغيير اي من الإسم او البريد الإلكتروني او الكلية الرجاء التواصل معا إدارة النقل الطلابي ',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
