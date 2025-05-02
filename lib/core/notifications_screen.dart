//added after removed
import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/core_widgets/notifications_widget.dart';
import 'package:uot_transport/core/core_widgets/uot_appbar.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: BackHeader(),
        backgroundColor: AppColors.backgroundColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 28, right: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    lbl: 'الإشعارات',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            //! edit
            SizedBox(height: 20),
            NotificationsWidget(
              notificationText: 'وصلت الحافلة 1 لمحطة قصر بن غشير',
            ),
            NotificationsWidget(
              notificationText: 'تأخرت الرحلة 10 دقائق عن الموعد المتوقع',
            ),
            NotificationsWidget(
              notificationText: 'وصلت الحافلة 1 لمحطة قصر بن غشير',
            ),
            NotificationsWidget(
              notificationText: 'تأخرت الرحلة 10 دقائق عن الموعد المتوقع',
            ),
            NotificationsWidget(
              notificationText: 'وصلت الحافلة 1 لمحطة قصر بن غشير',
            ),
            NotificationsWidget(
              notificationText: 'تأخرت الرحلة 10 دقائق عن الموعد المتوقع',
            ),
            NotificationsWidget(
              notificationText: 'وصلت الحافلة 1 لمحطة قصر بن غشير',
            ),
            NotificationsWidget(
              notificationText: 'تأخرت الرحلة 10 دقائق عن الموعد المتوقع',
            ),
          ],
        ),
      ),
    );
  }
}
