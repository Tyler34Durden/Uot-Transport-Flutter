import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_urls.dart';
import 'package:uot_transport/core/permissions_helper.dart';
import 'package:uot_transport/core/response_dialog.dart';
import 'package:uot_transport/features/auth_feature/presentation/screens/login_screen.dart' as clean_auth;
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_input.dart';
import 'package:uot_transport/core/widgets/app_text.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_image.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _phoneController = TextEditingController();

  static const String _privacyPolicyUrl = privacyPolicyUrl;

  @override
  void initState() {
    super.initState();
    // Load cached profile once provider exists.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().loadCached();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.maybeWhen(
          actionSuccess: (message, profile) {
            showResponseDialog(
              context,
              success: true,
              message: message,
            );
            if (profile != null) {
              _phoneController.text = profile.phone ?? '';
              context.read<ProfileCubit>().setProfile(profile);
            }
          },
          error: (message) {
            showResponseDialog(
              context,
              success: false,
              message: message,
            );
          },
          loggedOut: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => clean_auth.LoginScreen()),
              (route) => false,
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          initial: () => true,
          loading: () => true,
          orElse: () => false,
        );
        if (isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final errorMessage = state.maybeWhen(
          error: (message) => message,
          orElse: () => null,
        );
        if (errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().loadCached(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          );
        }

        final profile = state.maybeWhen(
          loaded: (profile) => profile,
          actionSuccess: (_, profile) => profile,
          orElse: () => null,
        );

        if (profile == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.read<ProfileCubit>().loadCached(),
                child: const Text('تحميل الملف الشخصي'),
              ),
            ),
          );
        }

        _phoneController.text =
            _phoneController.text.isEmpty ? (profile.phone ?? '') : _phoneController.text;

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: ProfileImageWidget(
                      imageUrl: profile.profilePhoto ?? '',
                      onEdit: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppText(
                          lbl: 'الإسم الثلاثي',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        AppText(lbl: profile.fullName, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        const AppText(
                          lbl: 'البريد الإلكتروني',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        AppText(lbl: profile.email, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        const AppText(
                          lbl: 'الكلية',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        AppText(lbl: profile.userZone, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        const AppText(
                          lbl: 'رقم الهاتف',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        AppInput(
                          prefixIcon: const Icon(Icons.phone_rounded),
                          controller: _phoneController,
                          style: const TextStyle(fontSize: 16),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                        const SizedBox(height: 10),
                        AppButton(
                          lbl: 'حفظ التغييرات',
                          onPressed: () => context.read<ProfileCubit>().updatePhone(
                                _phoneController.text.trim(),
                              ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                lbl: 'تغيير كلمة المرور',
                                color: AppColors.secondaryColor,
                                textColor: AppColors.primaryColor,
                                onPressed: () {
                                  final cubit = context.read<ProfileCubit>();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: cubit,
                                        child: const ChangePasswordScreen(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppButton(
                                lbl: 'تسجيل خروج',
                                color: AppColors.secondaryColor,
                                textColor: AppColors.primaryColor,
                                onPressed: () => context.read<ProfileCubit>().logout(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          lbl: 'سياسة الخصوصية',
                          width: double.infinity,
                          color: AppColors.secondaryColor,
                          textColor: AppColors.primaryColor,
                          onPressed: () async {
                            await PermissionsHelper.confirmAndOpenPrivacyPolicy(context, _privacyPolicyUrl);
                          },
                        ),
                        const SizedBox(height: 12),
                        const AppText(
                          lbl:
                              ' *في حالة الرغبة في تغيير أي من الإسم أو البريد الإلكتروني أو الكلية الرجاء التواصل مع إدارة النقل الطلابي',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

