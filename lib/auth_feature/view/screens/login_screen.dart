import 'package:flutter/material.dart';
                                            import 'package:flutter_bloc/flutter_bloc.dart';
                                            import 'package:uot_transport/auth_feature/view/screens/forgot_password.dart';
                                            import 'package:uot_transport/auth_feature/view/screens/signup_screen.dart';
                                            import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
                                            import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
                                            import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
                                            import 'package:uot_transport/core/core_widgets/back_header.dart';
                                            import 'package:uot_transport/core/app_colors.dart';
                                            import 'package:uot_transport/core/main_screen.dart';
                                            import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
                                            import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';
                                            import 'package:logger/logger.dart';
                                            import 'package:lottie/lottie.dart';

                                            import 'change_season.dart';

                                            class LoginScreen extends StatelessWidget {
                                              const LoginScreen({super.key});

                                              static final TextEditingController emailController = TextEditingController();
                                              static final TextEditingController passwordController = TextEditingController();
                                              static final logger = Logger();

                                              @override
                                              Widget build(BuildContext context) {
                                                final screenHeight = MediaQuery.of(context).size.height;
                                                final screenWidth = MediaQuery.of(context).size.width;
                                                final padding = screenWidth * 0.05;
                                                final titleFontSize = screenWidth * 0.07;
                                                final subtitleFontSize = screenWidth * 0.045;
                                                final labelFontSize = screenWidth * 0.04;
                                                final inputSpacing = screenHeight * 0.025;
                                                final buttonSpacing = screenHeight * 0.06;

                                                return PopScope(
                                                  canPop: false,
                                                  onPopInvoked: (didPop) {
                                                    if (didPop) {
                                                      return;
                                                    }
                                                    emailController.clear();
                                                    passwordController.clear();
                                                  },
                                                  child: Scaffold(
                                                    backgroundColor: AppColors.backgroundColor,
                                                    appBar: AppBar(
                                                      backgroundColor: Colors.transparent,
                                                      elevation: 0,
                                                      automaticallyImplyLeading: false,
                                                      toolbarHeight: 56,
                                                    ),
                                                    body: BlocListener<StudentAuthCubit, StudentAuthState>(
                                                      listener: (context, state) {
                                                        if (state is StudentAuthLoading) {
                                                          logger.i('Loading...');
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible: false,
                                                            builder: (context) => Dialog(
                                                              backgroundColor: AppColors.backgroundColor,
                                                              elevation: 0,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(16),
                                                              ),
                                                              child: Container(
                                                                width: MediaQuery.of(context).size.width * 0.8,
                                                                height: MediaQuery.of(context).size.width * 0.8,
                                                                padding: const EdgeInsets.all(12),
                                                                child: Lottie.asset(
                                                                  'assets/icons/DT_Loading.json',
                                                                  onLoaded: (composition) {
                                                                    // Get animation duration and ensure at least one full cycle
                                                                    Future.delayed(
                                                                      Duration(milliseconds: 5000),
                                                                          () {
                                                                        // This will prevent the dialog from closing too early
                                                                        // The dialog will still be closed by your existing state listener
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          Navigator.of(context, rootNavigator: true).popUntil((route) => route is! PopupRoute);
                                                          if (state is LoginSuccess) {
                                                            logger.i('Login successful');
                                                            emailController.clear();
                                                            passwordController.clear();
                                                            Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => const MainScreen()),
                                                              (route) => false, // Removes all previous routes so user can't go back
                                                            );
                                                          } else if (state is StudentAuthFailure) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text(state.error)),
                                                            );
                                                          } else if (state is SeasonChangeRequired) {
                                                            Future.microtask(() {
                                                              if (ModalRoute.of(context)?.isCurrent ?? true) {
                                                                showDialog(
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  builder: (BuildContext context) {
                                                                    return Directionality(
                                                                      textDirection: TextDirection.rtl,
                                                                      child: AlertDialog(
                                                                        title: const Align(
                                                                          alignment: Alignment.centerRight,
                                                                          child: Text('تحديث السنة الدراسية'),
                                                                        ),
                                                                        content: SizedBox(
                                                                          width: screenWidth * 0.8,
                                                                          child: SingleChildScrollView(
                                                                            child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'يجب عليك تحديث السنة الدراسية للمتابعة.',
                                                                                  style: TextStyle(fontSize: screenWidth * 0.045),
                                                                                ),
                                                                                SizedBox(height: screenHeight * 0.025),
                                                                                AppButton(
                                                                                  lbl: 'تحديث',
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(builder: (context) => const ChangeSeason()),
                                                                                    );
                                                                                  },
                                                                                  color: AppColors.primaryColor,
                                                                                  textColor: AppColors.backgroundColor,
                                                                                  width: screenWidth * 0.7,
                                                                                  height: screenHeight * 0.06,
                                                                                ),
                                                                                SizedBox(height: screenHeight * 0.015),
                                                                                AppButton(
                                                                                  lbl: 'إلغاء',
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  color: AppColors.secondaryColor,
                                                                                  textColor: AppColors.primaryColor,
                                                                                  width: screenWidth * 0.7,
                                                                                  height: screenHeight * 0.06,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          FocusScope.of(context).unfocus();
                                                        },
                                                        child: BlocBuilder<StudentAuthCubit, StudentAuthState>(
                                                          builder: (context, state) {
                                                            return SingleChildScrollView(
                                                              child: Padding(
                                                                padding: EdgeInsets.all(padding),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                  children: [
                                                                    Center(
                                                                      child: AppText(
                                                                        lbl: 'تسجيل الدخول',
                                                                        style: TextStyle(
                                                                          color: AppColors.primaryColor,
                                                                          fontSize: titleFontSize,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: inputSpacing * 0.8),
                                                                    AppText(
                                                                      textAlign: TextAlign.center,
                                                                      lbl: 'سجّل دخولك للوصول إلى خدمات النقل الجامعي بسهولة وراحة',
                                                                      style: TextStyle(
                                                                        color: AppColors.textColor,
                                                                        fontSize: subtitleFontSize,
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: inputSpacing * 1.5),
                                                                    AppText(
                                                                      lbl: 'ادخل بريدك الإلكتروني',
                                                                      style: TextStyle(
                                                                        color: AppColors.textColor,
                                                                        fontSize: labelFontSize,
                                                                      ),
                                                                      textAlign: TextAlign.right,
                                                                    ),
                                                                    SizedBox(height: inputSpacing * 0.8),
                                                                    AppInput(
                                                                      suffixIcon: const Icon(Icons.email_rounded),
                                                                      controller: emailController,
                                                                      hintText: 'البريد الالكتروني',
                                                                      textAlign: TextAlign.right,
                                                                    ),
                                                                    SizedBox(height: inputSpacing * 1.5),
                                                                    AppText(
                                                                      lbl: 'ادخل كلمة مرورك ',
                                                                      style: TextStyle(
                                                                        color: AppColors.textColor,
                                                                        fontSize: labelFontSize,
                                                                      ),
                                                                      textAlign: TextAlign.right,
                                                                    ),
                                                                    SizedBox(height: inputSpacing * 0.8),
                                                                    AppInput(
                                                                      suffixIcon: const Icon(Icons.lock_rounded),
                                                                      obscureText: true,
                                                                      controller: passwordController,
                                                                      hintText: 'كلمة المرور ',
                                                                      textAlign: TextAlign.right,
                                                                    ),
                                                                    SizedBox(height: inputSpacing * 0.8),
                                                                    AppText(
                                                                      lbl: 'هل نسيت كلمة مرورك؟',
                                                                      style: TextStyle(
                                                                        color: AppColors.primaryColor,
                                                                        fontSize: labelFontSize,
                                                                        decoration: TextDecoration.underline,
                                                                      ),
                                                                      textAlign: TextAlign.right,
                                                                      onTap: () {
                                                                        logger.i('Navigating to Forgot Password screen');
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) => const ForgotPassword(),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                    SizedBox(height: buttonSpacing),
                                                                    AppButton(
                                                                      lbl: 'تسجيل الدخول',
                                                                      onPressed: () {
                                                                        final email = emailController.text.trim();
                                                                        final password = passwordController.text;

                                                                        final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                                                                        final passwordRegExp = RegExp(
                                                                            r"""^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$])[A-Za-z\d@#$]{8,}$"""
                                                                        );

                                                                        if (email.isEmpty) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                            SnackBar(content: Text('الرجاء إدخال بريدك الإلكتروني')),
                                                                          );
                                                                          return;
                                                                        }
                                                                        if (!emailRegExp.hasMatch(email)) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                            SnackBar(content: Text('يرجى إدخال بريد إلكتروني صحيح')),
                                                                          );
                                                                          return;
                                                                        }
                                                                        if (password.isEmpty) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                            SnackBar(content: Text('الرجاء إدخال كلمة المرور')),
                                                                          );
                                                                          return;
                                                                        }
                                                                        if (!passwordRegExp.hasMatch(password)) {
                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                            SnackBar(
                                                                              content: Text(
                                                                                'يجب أن تتكوّن كلمة المرور من 8 أحرف على الأقل، وتشمل أحرفًا كبيرة وصغيرة، أرقامًا، ورموزًا خاصة مثل'
                                                                                ' (@، #، \$).'
                                                                              ),
                                                                            ),
                                                                          );
                                                                          return;
                                                                        }

                                                                        final loginData = {
                                                                          "email": email,
                                                                          "password": password,
                                                                        };
                                                                        logger.i('Attempting to login with data: $loginData');
                                                                        context.read<StudentAuthCubit>().login(loginData);
                                                                      },
                                                                    ),
                                                                    SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                                                                    SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                                                                    AppText(
                                                                      lbl: 'ليس لديك حساب؟ انشىء حساب',
                                                                      style: TextStyle(
                                                                        color: AppColors.primaryColor,
                                                                        fontSize: labelFontSize,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                      textAlign: TextAlign.center,
                                                                      onTap: () {
                                                                        logger.i('Navigating to Signup screen');
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                                                                        );
                                                                      },
                                                                    ),
                                                                    SizedBox(height: inputSpacing * 0.8),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }