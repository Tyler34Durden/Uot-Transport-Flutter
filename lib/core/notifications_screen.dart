import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/core_widgets/notifications_widget.dart';
import 'package:uot_transport/core/model/repository/notifications_repository.dart';
import 'package:uot_transport/core/view_model/cubit/notifications_cubit.dart';

import '../trips_feature/view/screens/mytrip_details_screen.dart';

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
      child: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final token = snapshot.data!;
          return BlocProvider(
            create: (_) => NotificationsCubit(NotificationsRepository())..fetchNotifications(token),
            child: Builder(
              builder: (context) {
                final media = MediaQuery.of(context);
                final screenWidth = media.size.width;
                final screenHeight = media.size.height;
                final horizontalPadding = screenWidth * 0.07; // Responsive padding
                final topPadding = screenHeight * 0.04; // Responsive top padding
                final titleFontSize = screenWidth * 0.06; // Responsive font size

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
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('auth_token');
                          if (token != null) {
                            await context.read<NotificationsCubit>().markAllAsRead(token);
                            await context.read<NotificationsCubit>().fetchNotifications(token);
                          }
                        },
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.backgroundColor,
                  body: BlocBuilder<NotificationsCubit, NotificationsState>(
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
                            Padding(
                              padding: EdgeInsets.only(
                                top: topPadding,
                                right: horizontalPadding,
                                left: horizontalPadding,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'إشعارات ($notificationCount)',
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
                                onRefresh: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  final token = prefs.getString('auth_token');
                                  if (token != null) {
                                    await context.read<NotificationsCubit>().fetchNotifications(token);
                                  }
                                },
                                child: ListView.builder(
                                  itemCount: state.notifications.length,
                                  itemBuilder: (context, index) {
                                    final notification = state.notifications[index];
                                    String notificationText = '';
                                    String notificationBody = '';
                                    if (notification is Map && notification['data'] is Map) {
                                      notificationText = notification['data']['title']?.toString() ?? '';
                                      notificationBody = notification['data']['body']?.toString() ?? '';
                                    } else {
                                      notificationText = notification.toString();
                                    }
                                    final notificationId = notification is Map && notification['id'] != null
                                        ? notification['id'].toString()
                                        : null;
                                    final isRead = notification is Map && notification['read_at'] != null;
                                    return GestureDetector(
                                      onTap: () async {
                                        if (notification is Map && notification['data'] is Map) {
                                          final data = notification['data'] as Map;
                                          if (data['type'] == 'trips' && data['id'] != null) {
                                            final tripId = data['id'].toString();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MyTripDetailsScreen(
                                                  tripId: tripId,
                                                  busId: '',
                                                  tripState: '',
                                                  firstTripRoute: const {},
                                                  lastTripRoute: const {},
                                                ),
                                              ),
                                            );
                                            return;
                                          }
                                        }
                                        if (notificationId != null) {
                                          final prefs = await SharedPreferences.getInstance();
                                          final token = prefs.getString('auth_token');
                                          if (token != null) {
                                            await context.read<NotificationsCubit>().markAsRead(notificationId, token);
                                            await context.read<NotificationsCubit>().fetchNotifications(token);
                                          }
                                        }
                                      },
                                      child: NotificationsWidget(
                                        notificationText: notificationText,
                                        notificationBody: notificationBody,
                                        isRead: isRead,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )                          ],
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
          );
        },
      ),
    );
  }
}