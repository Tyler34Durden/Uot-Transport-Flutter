import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/core_widgets/dt_loading.dart';
import 'package:uot_transport/core/locator.dart';

import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notifications_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsCubit _cubit;
  late final Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<NotificationsCubit>();
    _tokenFuture = _getToken();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await _tokenFuture;
      if (!mounted || token == null || token.isEmpty) return;
      _cubit.fetchNotifications(token);
    });
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: FutureBuilder<String?>(
        future: _tokenFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: DTLoading());
          }
          final token = snapshot.data;
          if (token == null || token.isEmpty) {
            return const Center(child: Text('يرجى تسجيل الدخول أولاً'));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              elevation: 0,
              leading: const BackHeader(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.done_all, color: AppColors.primaryColor),
                  tooltip: 'تحديد الكل كمقروء',
                  onPressed: () async {
                    await _cubit.markAllAsRead(token);
                    await _cubit.fetchNotifications(token);
                  },
                ),
              ],
            ),
            backgroundColor: AppColors.backgroundColor,
            body: BlocBuilder<NotificationsCubit, NotificationsState>(
              bloc: _cubit,
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  initial: () => true,
                  loading: () => true,
                  orElse: () => false,
                );
                if (isLoading) {
                  return const Center(child: DTLoading());
                }

                final errorMessage = state.maybeWhen(
                  error: (message) => message,
                  orElse: () => null,
                );
                if (errorMessage != null) {
                  return Center(
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.primaryColor),
                    ),
                  );
                }

                final notifications = state.maybeWhen(
                  loaded: (notifications) => notifications,
                  orElse: () => null,
                );

                if (notifications == null) {
                  return const Center(child: DTLoading());
                }

                final count = notifications.length;
                if (count == 0) {
                  return const Center(child: Text('لا توجد إشعارات'));
                }

                final media = MediaQuery.of(context);
                final screenWidth = media.size.width;
                final screenHeight = media.size.height;
                final horizontalPadding = screenWidth * 0.07;
                final topPadding = screenHeight * 0.04;
                final titleFontSize = screenWidth * 0.06;

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: topPadding,
                        right: horizontalPadding,
                        left: horizontalPadding,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'إشعارات ($count)',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => _cubit.fetchNotifications(token),
                        child: ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final n = notifications[index];

                            return NotificationsWidget(
                              notificationText: n.title,
                              notificationBody: n.body,
                              isRead: n.isRead,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
