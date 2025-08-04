import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? 'إشعار جديد',
    message.notification?.body ?? 'No message body',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init(
    GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    BuildContext context,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');

    String? token = await _firebaseMessaging.getToken();
    print('Firebase Messaging Token: $token');

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notificationBody = message.notification?.body ?? message.data['body'] ?? 'No message body';
      final notificationTitle = message.notification?.title ?? message.data['title'] ?? 'إشعار جديد';

      Flushbar(
        title: notificationTitle,
        message: notificationBody,
        backgroundColor: AppColors.backgroundColor,
        duration: const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(8),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        titleColor: AppColors.primaryColor,
        messageColor: AppColors.textColor,
      ).show(context);
    });

    // When notification is tapped
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notificationBody = message.notification?.body ?? message.data['body'] ?? 'Notification clicked!';
      final notificationTitle = message.notification?.title ?? message.data['title'] ?? 'إشعار جديد';

      Flushbar(
        titleText: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            notificationTitle,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        messageText: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            notificationBody,
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 14,
            ),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        duration: const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.zero,
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        boxShadows: [
          const BoxShadow(
            color: Colors.blue,
            offset: Offset(0, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
          const BoxShadow(
            color: Colors.blue,
            offset: Offset(0, 4),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ).show(navigatorKey.currentContext!);
    });
  }
}