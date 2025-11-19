import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewScreen extends StatelessWidget {
  final String url;
  final String title;
  const WebviewScreen({super.key, required this.url, this.title = 'محتوى'});

  Future<void> _openExternally(BuildContext context) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Align(alignment: Alignment.centerRight, child: Text('خطأ')),
            content: Text('تعذر فتح الرابط في المتصفح: ${e.toString()}'),
            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('حسناً'))],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Text(title),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('سيتم فتح سياسة الخصوصية خارج التطبيق.'),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _openExternally(context),
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('فتح في المتصفح'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
