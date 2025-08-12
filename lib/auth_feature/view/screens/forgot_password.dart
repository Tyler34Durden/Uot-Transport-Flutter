import 'package:flutter/material.dart';
            import 'package:flutter_bloc/flutter_bloc.dart';
            import 'package:uot_transport/auth_feature/view/screens/password_otp_screen.dart';
            import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
            import 'package:uot_transport/auth_feature/view/widgets/app_input.dart';
            import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
            import 'package:uot_transport/core/core_widgets/back_header.dart';
            import 'package:uot_transport/core/app_colors.dart';
            import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
            import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_state.dart';

            class ForgotPassword extends StatefulWidget {
              const ForgotPassword({super.key});

              @override
              State<ForgotPassword> createState() => _ForgotPasswordState();
            }

            class _ForgotPasswordState extends State<ForgotPassword> {
              final TextEditingController emailController = TextEditingController();

              @override
              void dispose() {
                emailController.dispose();
                super.dispose();
              }

              @override
              Widget build(BuildContext context) {
                final screenHeight = MediaQuery.of(context).size.height;

                return Scaffold(
                  backgroundColor: AppColors.backgroundColor,
                  appBar: const BackHeader(),
                  body: BlocConsumer<StudentAuthCubit, StudentAuthState>(
                    listener: (context, state) {
                      if (state is ForgotPasswordSuccess) {
                        // Store email in a variable to ensure it's captured
                        final email = emailController.text.trim();
                        print("Email being passed: $email"); // Debug print

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordOtp(email: email),
                          ),
                        );
                      } else if (state is StudentAuthFailure) {
                        // Show DioError response message if available
                        dynamic errorMsg = state.error;
                        if (errorMsg is Map && errorMsg['message'] != null) {
                          errorMsg = errorMsg['message'].toString();
                        } else if (errorMsg is String) {
                          // Try to extract {message: ...} from any part of the string
                          final regex = RegExp(r'Error Data: \{message: ([^}]+)\}');
                          final match = regex.firstMatch(errorMsg);
                          if (match != null) {
                            errorMsg = match.group(1)?.trim() ?? errorMsg;
                          } else {
                            // Fallback: Try to extract {message: ...} from any part of the string
                            final fallbackRegex = RegExp(r'\{message: ([^}]+)\}');
                            final fallbackMatch = fallbackRegex.firstMatch(errorMsg);
                            if (fallbackMatch != null) {
                              errorMsg = fallbackMatch.group(1)?.trim() ?? errorMsg;
                            } else {
                              // If no message found, show only the first line or a generic message
                              errorMsg = errorMsg.split('\n').first;
                            }
                          }
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMsg)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: screenHeight * 0.04),
                              const Center(
                                child: AppText(
                                  lbl: 'إسترجاع كلمة المرور ',
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
                                lbl: 'دخل بياناتك ليتم إرسال اليك رمز تحقق لكي تعد تعيين كلمة مرورك',
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.06),
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
                                hintText: 'البريد الالكتروني',
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              AppButton(
                                lbl: ' إعادة تعيين كلمة المرور',
                                onPressed: () {
                                  final email = emailController.text.trim();
                                  final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

                                  if (email.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('الرجاء إدخال بريدك الإلكتروني')),
                                    );
                                    return;
                                  }
                                  if (!emailRegExp.hasMatch(email)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('يرجى إدخال بريد إلكتروني صحيح')),
                                    );
                                    return;
                                  }

                                  context.read<StudentAuthCubit>().forgotPassword(email);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }