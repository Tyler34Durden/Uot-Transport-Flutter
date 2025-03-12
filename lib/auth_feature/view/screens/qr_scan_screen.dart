import 'package:flutter/material.dart';
                      import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';

                      class QRScanScreen extends StatefulWidget {
                        const QRScanScreen({super.key});

                        @override
                        _QRScanScreenState createState() => _QRScanScreenState();
                      }

                      class _QRScanScreenState extends State<QRScanScreen> {
                        MobileScannerController controller = MobileScannerController();

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
                                onBackbtn: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            body: Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: MobileScanner(
                                    controller: controller,
                                    onDetect: (barcodeCapture) {
                                      final barcodes = barcodeCapture.barcodes;
                                      for (final barcode in barcodes) {
                                        if (barcode.rawValue != null) {
                                          final String code = barcode.rawValue!;
                                          print('Barcode found! $code');
                                          Navigator.pop(context, code);
                                          break;
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text('امسح رمز نموذج 2',
                                    style:
                                      TextStyle(
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
