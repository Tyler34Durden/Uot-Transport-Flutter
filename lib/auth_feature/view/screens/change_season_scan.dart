//added after removed
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:logger/logger.dart';

class ChangeSeasonScan extends StatefulWidget {

  const ChangeSeasonScan({super.key,});

  @override
  _ChangeSeasonScanState createState() => _ChangeSeasonScanState();
}

class _ChangeSeasonScanState extends State<ChangeSeasonScan> {
  MobileScannerController controller = MobileScannerController();
  bool hasScanned = false;
  final Logger logger = Logger();

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
        child: BackHeader(
          onBackbtn: () => Navigator.pop(context),
        ),
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
                  if (barcode.rawValue != null) {
                    final String code = barcode.rawValue!;
                    logger.i('Barcode found! $code');
                    setState(() {
                      hasScanned = true;
                    });
                    Navigator.pop(context, code);
                    break;
                  }
                }
              },
              errorBuilder: (context, error, child) {
                logger.e('MobileScanner error: $error');
                return Center(
                  child: Text(
                    'Camera error: $error',
                    style: const TextStyle(color: Colors.red),
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