import 'package:flutter/material.dart';
                        import 'package:uot_transport/auth_feature/view/screens/confirm_study_status_screen.dart';
                        import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
                        import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
                        import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
                        import 'package:uot_transport/core/core_widgets/back_header.dart';
                        import 'package:uot_transport/core/app_colors.dart';

                        class SignupScreen extends StatelessWidget {
                          const SignupScreen({super.key});

                          static final TextEditingController fullNameController = TextEditingController();
                          static final TextEditingController emailController = TextEditingController();
                          static final TextEditingController passwordController = TextEditingController();
                          static final TextEditingController confirmPasswordController = TextEditingController();

                          @override
                          Widget build(BuildContext context) {
                            final screenHeight = MediaQuery.of(context).size.height;
                            final screenWidth = MediaQuery.of(context).size.width;

                            return WillPopScope(
                              onWillPop: () async {
                                fullNameController.clear();
                                emailController.clear();
                                passwordController.clear();
                                confirmPasswordController.clear();
                                return true;
                              },
                              child: Scaffold(
                                backgroundColor: AppColors.backgroundColor,
                                appBar: BackHeader(
                                  onBackbtn: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                body: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          const Center(
                                            child: AppText(
                                              lbl: 'إنشاء حساب ',
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
                                            lbl: 'أنشئ حساباً جديداً واستمتع بتجربة نقل جامعي مريحة ومميزة.',
                                            style: TextStyle(
                                              color: AppColors.textColor,
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.04),
                                          const AppText(
                                            lbl: 'ادخل اسمك الثلاثي  ',
                                            style: TextStyle(
                                              color: AppColors.textColor,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          AppInput(
                                            suffixIcon: const Icon(Icons.person_rounded),
                                            controller: fullNameController,
                                            hintText: 'الاسم الثلاثي ',
                                            textAlign: TextAlign.right,
                                            maxLength: 30,
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          const AppText(
                                            lbl: 'ادخل بريدك الإلكتروني',
                                            style: TextStyle(
                                              color: AppColors.textColor,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          AppInput(
                                            suffixIcon: const Icon(Icons.email_rounded),
                                            controller: emailController,
                                            hintText: 'البريد الإلكتروني ',
                                            textAlign: TextAlign.right,
                                            maxLength: 40,
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          const AppText(
                                            lbl: 'ادخل كلمة مرورك  ',
                                            style: TextStyle(
                                              color: AppColors.textColor,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          AppInput(
                                            suffixIcon: const Icon(Icons.lock_open_rounded),
                                            obscureText: true,
                                            controller: passwordController,
                                            hintText: 'كلمة المرور  ',
                                            textAlign: TextAlign.right,
                                            maxLength: 25,
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          const AppText(
                                            lbl: 'تأكيد كلمة المرور',
                                            style: TextStyle(
                                              color: AppColors.textColor,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          AppInput(
                                            suffixIcon: const Icon(Icons.lock_rounded),
                                            obscureText: true,
                                            controller: confirmPasswordController,
                                            hintText: 'كلمة المرور (تأكيد)',
                                            textAlign: TextAlign.right,
                                            maxLength: 25,
                                          ),
                                          SizedBox(height: screenHeight * 0.06),
                                          AppButton(
                                            lbl: 'التالي ',
                                            width: screenWidth * 0.4,
                                            height: screenHeight * 0.07,
                                            onPressed: () {
                                              final fullName = fullNameController.text.trim();
                                              final email = emailController.text.trim();
                                              final password = passwordController.text;
                                              final confirmPassword = confirmPasswordController.text;

                                              final nameRegExp = RegExp(r'^[\p{L} ]+$', unicode: true); // Letters and spaces
                                              final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                                              final passwordRegExp = RegExp(
                                                  r"""^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$])[A-Za-z\d@#$]{8,}$"""
                                              );

                                              if (fullName.isEmpty) {
                                                showError(context, 'الرجاء إدخال اسمك الثلاثي');
                                                return;
                                              }
                                              if (!nameRegExp.hasMatch(fullName)) {
                                                showError(context, 'يجب أن يحتوي الاسم على أحرف فقط');
                                                return;
                                              }
                                              if (email.isEmpty) {
                                                showError(context, 'الرجاء إدخال بريدك الإلكتروني');
                                                return;
                                              }
                                              if (!emailRegExp.hasMatch(email)) {
                                                showError(context, 'يرجى إدخال بريد إلكتروني صحيح');
                                                return;
                                              }
                                              if (password.isEmpty) {
                                                showError(context, 'الرجاء إدخال كلمة المرور');
                                                return;
                                              }
                                               if (!passwordRegExp.hasMatch(password)) {
                                                 showError(context, """يجب أن تتكوّن كلمة المرور من 8 أحرف على الأقل، وتشمل أحرفًا كبيرة وصغيرة، أرقامًا، ورموزًا خاصة مثل
                                                  (@، #، \$).""");
                                                 return;
                                              }
                                              if (password != confirmPassword) {
                                                showError(context, 'كلمة المرور وتأكيد كلمة المرور غير متطابقتين');
                                                return;
                                              }

                                              final studentData = {
                                                'fullName': fullName,
                                                'email': email,
                                                'password': password,
                                                'password_confirmation': confirmPassword,
                                              };
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ConfirmStudyStatusScreen(
                                                    studentData: studentData,
                                                    fullNameController: fullNameController,
                                                    emailController: emailController,
                                                    passwordController: passwordController,
                                                    confirmPasswordController: confirmPasswordController,
                                                  ),
                                                ),
                                              );
                                            }
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          void showError(BuildContext context, String message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          }
                        }