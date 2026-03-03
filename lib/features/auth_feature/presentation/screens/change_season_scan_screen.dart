import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';

class ChangeSeasonScanScreen extends StatefulWidget {
  const ChangeSeasonScanScreen({super.key});

  @override
  State<ChangeSeasonScanScreen> createState() => _ChangeSeasonScanScreenState();
}

class _ChangeSeasonScanScreenState extends State<ChangeSeasonScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  final Logger logger = Logger();

  bool hasScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: BackHeader(onBackbtn: () => Navigator.pop(context)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              onDetect: (barcodeCapture) {
                if (hasScanned) return;
                final barcodes = barcodeCapture.barcodes;
                for (final barcode in barcodes) {
                  final raw = barcode.rawValue;
                  if (raw == null) continue;
                  logger.i('Barcode found! $raw');
                  setState(() {
                    hasScanned = true;
                  });
                  Navigator.pop(context, raw);
                  break;
                }
              },
              errorBuilder: (context, error) {
                logger.e('MobileScanner error: $error');
                return Center(
                  child: Text(
                    'Camera error: $error',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'امسح رمز نموذج 2',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

