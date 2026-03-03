import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({
    super.key,
    required this.location,
  });
  final String location;
  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}
class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  LatLng _parseLocation(String location) {
    if (location.contains(',')) {
      final parts = location.split(',');
      if (parts.length >= 2) {
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) return LatLng(lat, lng);
      }
    }
    return const LatLng(0.0, 0.0);
  }
  @override
  Widget build(BuildContext context) {
    final stationLatLng = _parseLocation(widget.location);
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: stationLatLng, zoom: 16.0),
          markers: {
            Marker(
              markerId: const MarkerId('station_location'),
              position: stationLatLng,
            ),
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }
}
