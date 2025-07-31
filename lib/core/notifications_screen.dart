//added after removed
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/core_widgets/notifications_widget.dart';
import 'package:uot_transport/core/core_widgets/uot_appbar.dart';
import 'package:uot_transport/core/model/repository/notifications_repository.dart';
import 'package:uot_transport/core/view_model/cubit/notifications_cubit.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BackHeader(),
        backgroundColor: AppColors.backgroundColor,
        body: FutureBuilder<String?>(
          future: _getToken(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final token = snapshot.data!;
            return BlocProvider(
              create: (_) => NotificationsCubit(NotificationsRepository())
                ..fetchNotifications(token),
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationsLoaded) {
                    final notificationCount = state.notifications.length;
                    if (notificationCount == 0) {
                      return const Center(child: Text('لا توجد إشعارات'));
                    }
                    return Column(
                      children: [
                        // Inside your NotificationsLoaded branch, replace the Row with:
                        Padding(
                          padding: const EdgeInsets.only(top: 28, right: 28, left: 28),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'إشعارات ($notificationCount)',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.notifications.length,
                            itemBuilder: (context, index) {
                              final notification = state.notifications[index];
                              final notificationText = notification is Map && notification['data'] is Map && notification['data']['body'] != null
                                  ? notification['data']['body'].toString()
                                  : notification.toString();
                              final notificationId = notification is Map && notification['id'] != null
                                  ? notification['id'].toString()
                                  : null;
                              final isRead = notification is Map && notification['read_at'] != null;
                              return GestureDetector(
                                onTap: () async {
                                  if (notificationId != null) {
                                    final prefs = await SharedPreferences.getInstance();
                                    final token = prefs.getString('auth_token');
                                    if (token != null) {
                                      await context.read<NotificationsCubit>().markAsRead(notificationId, token);
                                      // Refresh notifications after marking as read
                                      await context.read<NotificationsCubit>().fetchNotifications(token);
                                    }
                                  }
                                },
                                child: NotificationsWidget(
                                  notificationText: notificationText,
                                  isRead: isRead,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is NotificationsError) {
                    final isNoRouteToHost = state.message.contains('No route to host');
                    if (isNoRouteToHost) {
                      return const Center(
                        child: Text(
                          'لا يوجد اتصال بالخادم',
                          style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                        ),
                      );
                    }
                    return Center(child: Text('خطأ: ${state.message}'));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
