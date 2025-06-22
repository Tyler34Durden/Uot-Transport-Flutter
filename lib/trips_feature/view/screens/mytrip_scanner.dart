import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/trips_feature/view/screens/mytrip_details_screen.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';

class MyTripScanner extends StatefulWidget {
  final dynamic tripRouteId;
  final dynamic tripId;
  final String token;
  final String busId;
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const MyTripScanner({
    super.key,
    required this.tripRouteId,
    required this.token,
    required this.tripId, required this.busId, required this.tripState, required this.firstTripRoute, required this.lastTripRoute,
  });

  @override
  State<MyTripScanner> createState() => _MyTripScannerState();
}

class _MyTripScannerState extends State<MyTripScanner> {
  bool _scanned = false;
  final Logger _logger = Logger();

  Map<String, String> _parseQrData(String data) {
    final parts = data.split(',');
    final map = <String, String>{};
    for (var part in parts) {
      final kv = part.split(':');
      if (kv.length == 2) {
        map[kv[0].trim()] = kv[1].trim();
      }
    }
    return map;
  }

  void _handleScan(String code) async {
    if (_scanned) return;
    setState(() => _scanned = true);

    final qrData = _parseQrData(code);
    _logger.i('Scanned QR Data: $qrData');

    final scannedTripId = qrData['tripId'];
    final scannedTripRouteId = qrData['tripRouteId'];

    if (scannedTripId == widget.tripId.toString()) {
      _logger.i('Trip ID is correct');
      await context.read<TripsCubit>().updateTicketState(
        tripRouteId: int.parse(scannedTripRouteId ?? widget.tripRouteId.toString()),
        token: widget.token,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyTripDetailsScreen(
            tripId: widget.tripId.toString(),
            busId: widget.busId,
            tripState: widget.tripState,
            firstTripRoute: widget.firstTripRoute,
            lastTripRoute: widget.lastTripRoute,
          ),
        ),
      );
    } else {
      _logger.w('Trip ID is incorrect');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرحلة غير صحيحة، حاول مرة أخرى'),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _scanned = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackHeader(),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;
          if (code != null) {
            _handleScan(code);
          }
        },
      ),
    );
  }
}