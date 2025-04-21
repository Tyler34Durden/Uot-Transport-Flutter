
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/profile_feature/view/widgets/profile_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _token = '';
  Map<String, dynamic> _user = {};
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _logger.i('ProfileScreen initState called');
    _loadLoginData();
  }

  // نسترجع بيانات المستخدم المخزنة أثناء التسجيل الدخول
  Future<void> _loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token') ?? '';
      final userProfileString = prefs.getString('user_profile') ?? '';
      if (userProfileString.isNotEmpty) {
        _user = jsonDecode(userProfileString);
      } else {
        _logger.w('No user data found in SharedPreferences.');
        _user = {};
      }
      _phoneController.text = _user['phone'] ?? '';
    });
    _logger.i('Loaded token: $_token');
    _logger.i('Loaded user data: $_user');
  }

  // عند حفظ التغييرات نقوم بتحديث رقم الهاتف وتخزين بيانات المستخدم مجدداً
  Future<void> _saveChanges() async {
    setState(() {
      _user['phone'] = _phoneController.text.trim();
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', jsonEncode(_user));
    _logger.i('User profile updated: $_user');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التغييرات بنجاح!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building profile screen');
    if (_token.isEmpty || _user.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'بيانات المستخدم غير موجودة، يرجى إعادة تسجيل الدخول',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await _loadLoginData();
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: ProfileImageWidget(
                  imageUrl: _user['profilePhoto'] ?? '',
                  onEdit: () {
                    _logger.i('Edit icon tapped');
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
                      lbl: _user['fullName'] ?? '',
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
                      lbl: _user['email'] ?? '',
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
                      lbl: _user['userZone'] ?? 'كلية تقنية المعلومات',
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
                      onPressed: _saveChanges,
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      lbl: 'تسجيل خروج',
                      color: AppColors.secondaryColor,
                      textColor: AppColors.primaryColor,
                      onPressed: () {
                        _logger.i('Logout button pressed');
                        // تنفيذ منطق تسجيل الخروج
                      },
                    ),
                    const SizedBox(height: 20),
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
  }
}