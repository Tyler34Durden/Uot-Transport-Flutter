import 'package:flutter/material.dart';
                        import 'package:mobile_scanner/mobile_scanner.dart';
                        import 'package:uot_transport/core/core_widgets/back_header.dart';
                        import 'package:uot_transport/core/app_colors.dart';

                        class QRScanScreen extends StatefulWidget {
                          final String uotNumber;

                          const QRScanScreen({super.key, required this.uotNumber});

                          @override
                          _QRScanScreenState createState() => _QRScanScreenState();
                        }

                        class _QRScanScreenState extends State<QRScanScreen> {
                          MobileScannerController controller = MobileScannerController();
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
                                            print('Barcode found! $code');
                                            if (code.contains(widget.uotNumber)) {
                                              setState(() {
                                                hasScanned = true;
                                              });
                                              Navigator.pop(context, code);
                                            } else {
                                              print('Scanned code does not match UOT number.');
                                            }
                                            break;
                                          }
                                        }
                                      },
                                      errorBuilder: (context, error, child) {
                                        print('MobileScanner error: $error');
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