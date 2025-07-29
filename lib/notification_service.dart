import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_notification_banner.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init(GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey) async {
    // طلب إذن الإشعارات (ضروري لبعض الأنظمة)
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print('User granted permission: ${settings.authorizationStatus}');

    // استرجاع التوكن واختباره
    String? token = await _firebaseMessaging.getToken();
    print('Firebase Messaging Token: $token');

    // استقبال الرسائل عندما يكون التطبيق في الواجهة النشطة
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received full FCM message: ' + message.toString());
      print('Received FCM message data: ' + message.data.toString());
      print('Received FCM notification: ' + message.notification.toString());
      final notificationBody = message.notification?.body ?? message.data['body'] ?? 'No message body';
      final notificationTitle = message.notification?.title ?? message.data['title'] ?? 'إشعار جديد';
      print('Received a message in foreground: $notificationBody');
      if (scaffoldMessengerKey.currentState != null) {
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating, // Add this line
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notificationTitle,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  notificationBody,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.backgroundColor,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // No radius
              side: BorderSide(
                color: AppColors.primaryColor,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            margin: const EdgeInsets.only(top: 0, left: 0, right: 0), // Full width, top of screen
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });

    // استقبال الأحداث عند النقر على إشعار في حالة فتح التطبيق
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
      print('Full message on click: ' + message.toString());
      if (scaffoldMessengerKey.currentState != null) {
        scaffoldMessengerKey.currentState!.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating, // Add this line
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.notification?.title ?? message.data['title'] ?? 'إشعار جديد',
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.notification?.body ?? message.data['body'] ?? 'Notification clicked!',
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.backgroundColor,
            elevation: 8,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // No radius
              side: BorderSide(
                color: AppColors.primaryColor,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            margin: const EdgeInsets.only(top: 0, left: 0, right: 0), // Full width, top of screen
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });

    // تسجيل معالج الرسائل في الخلفية
    // (No-op: background notifications will be handled by FCM system tray)
  }
}

// No background handler needed for SnackBar-only foreground notifications.
