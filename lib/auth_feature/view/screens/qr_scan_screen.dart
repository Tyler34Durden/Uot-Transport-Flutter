//added after removed
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../../core/core_widgets/dt_loading.dart';

class QRScanScreen extends StatefulWidget {
  final String? uotNumber;

  const QRScanScreen({super.key, this.uotNumber});

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  MobileScannerController controller = MobileScannerController();
  bool hasScanned = false;
  bool isLoading = false;
  String? errorMessage;
  final Logger logger = Logger();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Scan QR from the image
      final scannedCode = await _scanQRFromImage(image.path);
      
      setState(() {
        isLoading = false;
      });
      
      if (scannedCode != null) {
        if (widget.uotNumber == null || scannedCode.contains(widget.uotNumber!)) {
          setState(() {
            hasScanned = true;
          });
          Navigator.pop(context, scannedCode);
        } else {
          setState(() {
            errorMessage = 'الرمز المسحوب لا يتطابق مع الرقم المطلوب';
          });
        }
      } else {
        setState(() {
          errorMessage = 'لم يتم العثور على رمز QR في الصورة';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'حدث خطأ أثناء معالجة الصورة: ${e.toString()}';
      });
      logger.e('Image picker error: $e');
    }
  }

  Future<String?> _scanQRFromImage(String imagePath) async {
    try {
      final MobileScannerController scannerController = MobileScannerController();
      final result = await scannerController.analyzeImage(imagePath);
      
      if (result != null && result.barcodes.isNotEmpty) {
        for (final barcode in result.barcodes) {
          if (barcode.rawValue != null) {
            scannerController.dispose();
            logger.i('Barcode found in image: ${barcode.rawValue}');
            return barcode.rawValue;
          }
        }
      }
      scannerController.dispose();
      return null;
    } catch (e) {
      logger.e('QR scanning error: $e');
      return null;
    }
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
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: (barcodeCapture) {
                    if (hasScanned) return;
                    final barcodes = barcodeCapture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        final String code = barcode.rawValue!;
                        logger.e('Barcode found! $code');
                        // If uotNumber is provided, check for match, else accept any scan
                        if (widget.uotNumber == null || code.contains(widget.uotNumber!)) {
                          setState(() {
                            hasScanned = true;
                          });
                          Navigator.pop(context, code);
                        } else {
                          setState(() {
                            errorMessage = 'الرمز المسحوب لا يتطابق مع الرقم المطلوب';
                          });
                          logger.e('Scanned code does not match UOT number.');
                        }
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
                if (isLoading)
                  Container(
                    color: Colors.white.withOpacity(0.8),
                    child: Center(
                      child: DTLoading()
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Text(
                  'امسح رمز نموذج 2',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('اختيار من المعرض'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}