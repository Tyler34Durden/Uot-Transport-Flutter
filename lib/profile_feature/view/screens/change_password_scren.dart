import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:uot_transport/core/response_dialog.dart';

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
      showResponseDialog(
        context,
        success: false,
        message: 'كلمة المرور الجديدة غير متطابقة مع التأكيد',
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
        showResponseDialog(
          context,
          success: true,
          message: response.data['message'],
        );
        // Navigator.pop(context);
      } else {
        throw Exception('بيانات الاستجابة غير صالحة');
      }
    } catch (e) {
      showResponseDialog(
        context,
        success: false,
        message: 'فشل تغيير كلمة المرور: ${e.toString()}',
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
                  lbl: 'تغيير كلمة المرور',
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
                suffixIcon: const Icon(Icons.lock_open_rounded),
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
                suffixIcon: const Icon(Icons.lock_rounded),
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
                suffixIcon: const Icon(Icons.lock_rounded),
                controller: _confirmPasswordController,
                hintText: 'أعد إدخال كلمة المرور الجديدة',
                textAlign: TextAlign.right,
                obscureText: true,
              ),
              SizedBox(height: screenHeight * 0.04),
              AppButton(
                lbl: 'تغيير كلمة المرور',
                onPressed: _changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
