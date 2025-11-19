import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class PermissionsHelper {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    final result = await Permission.camera.request();
    if (result.isGranted) return true;

    // Show rational dialog
    if (result.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Camera permission'),
          content: const Text('Please enable camera permission from settings to scan QR codes.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open settings'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  static Future<bool> requestPhotosPermission(BuildContext context) async {
    // On Android 13+ this maps to READ_MEDIA_IMAGES via permission_handler
    final permissions = [Permission.photos, Permission.storage];

    // Request both relevant permissions and inspect the returned map
    final statuses = await permissions.request();

    // If either permission was granted, we can proceed
    if (statuses[Permission.photos]?.isGranted == true || statuses[Permission.storage]?.isGranted == true) {
      return true;
    }

    // If any permission was permanently denied, show a dialog with settings shortcut
    final permanentlyDenied = permissions.any((p) => statuses[p]?.isPermanentlyDenied == true);
    if (permanentlyDenied) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Photos permission'),
          content: const Text('Please enable photos permission from settings to pick images from gallery.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open settings'),
            ),
          ],
        ),
      );
      return false;
    }

    // If not granted and not permanently denied, try requesting storage explicitly as a fallback
    final result = await Permission.storage.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Photos permission'),
          content: const Text('Please enable photos permission from settings to pick images from gallery.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open settings'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  static Future<bool> requestLocationPermission(BuildContext context) async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isGranted) return true;

    final result = await Permission.locationWhenInUse.request();
    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location permission'),
          content: const Text('Please enable location permission from settings to use maps and location features.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Open settings'),
            ),
          ],
        ),
      );
    }
    return false;

  }

  /// Try to open the provided URL externally. If a [context] is provided the method
  /// will show an error dialog when launching fails.
  static Future<void> openPrivacyPolicy(BuildContext? context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (context != null) {
        await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Align(alignment: Alignment.centerRight, child: Text('خطأ')),
              content: const Text('رابط سياسة الخصوصية غير صالح.'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً')),
              ],
            ),
          ),
        );
      }
      return;
    }

    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context != null) {
        // Offer to copy the link so the user can open it manually
        final action = await showDialog<String>(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Align(alignment: Alignment.centerRight, child: Text('تعذر الفتح')),
              content: const Text('تعذر فتح الرابط في المتصفح. هل تريد نسخ الرابط لفتحه يدويًا؟'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop('cancel'), child: const Text('إلغاء')),
                TextButton(onPressed: () => Navigator.of(context).pop('copy'), child: const Text('نسخ الرابط')),
              ],
            ),
          ),
        );

        if (action == 'copy') {
          await Clipboard.setData(ClipboardData(text: url));
          await showDialog(
            context: context,
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Align(alignment: Alignment.centerRight, child: Text('تم النسخ')),
                content: const Text('تم نسخ رابط سياسة الخصوصية إلى الحافظة. يمكنك لصقه في متصفحك.'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً')),
                ],
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (context != null) {
        final action = await showDialog<String>(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Align(alignment: Alignment.centerRight, child: Text('خطأ')),
              content: Text('حدث خطأ أثناء محاولة فتح الرابط: ${e.toString()}\n\nهل تريد نسخ الرابط لفتحه يدويًا؟'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop('cancel'), child: const Text('إلغاء')),
                TextButton(onPressed: () => Navigator.of(context).pop('copy'), child: const Text('نسخ الرابط')),
              ],
            ),
          ),
        );

        if (action == 'copy') {
          await Clipboard.setData(ClipboardData(text: url));
          await showDialog(
            context: context,
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Align(alignment: Alignment.centerRight, child: Text('تم النسخ')),
                content: const Text('تم نسخ رابط سياسة الخصوصية إلى الحافظة. يمكنك لصقه في متصفحك.'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً')),
                ],
              ),
            ),
          );
        }
      }
    }
  }

  /// Show a confirmation dialog (RTL) and open the URL externally if the user confirms.
  static Future<void> confirmAndOpenPrivacyPolicy(BuildContext context, String url) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Align(
              alignment: Alignment.centerRight,
              child: Text('سياسة الخصوصية'),
            ),
            content: const Text('سيتم فتح سياسة الخصوصية في متصفح خارجي. هل تريد المتابعة؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('فتح'),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true) {
      // Open externally (no in-app WebView)
      await openPrivacyPolicy(context, url);
    }
  }
}
