import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/features/trips_feature/presentation/widgets/active_trips_widget.dart'
    as clean_trips;

class ActiveTripsWidget extends StatefulWidget {
  const ActiveTripsWidget({
    super.key,
    required this.busId,
    required this.tripId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  final String busId;
  final String tripId;
  final dynamic tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  @override
  State<ActiveTripsWidget> createState() => _ActiveTripsWidgetState();
}

class _ActiveTripsWidgetState extends State<ActiveTripsWidget> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _token = prefs.getString('auth_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    final token = _token;
    if (token == null || token.isEmpty) {
      // Render non-clickable tile if token missing.
      return const SizedBox.shrink();
    }

    return clean_trips.ActiveTripsWidget(
      busId: widget.busId,
      tripId: widget.tripId,
      tripState: widget.tripState?.toString() ?? '',
      firstTripRoute: widget.firstTripRoute,
      lastTripRoute: widget.lastTripRoute,
      token: token,
    );
  }
}
