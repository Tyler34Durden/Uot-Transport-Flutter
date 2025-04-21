import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  final String location;
  const GoogleMapWidget({
    super.key,
    required this.location,
  });

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // دالة لتحليل الإحداثيات من قيمة الموقع المفردة
  LatLng _parseLocation(String location) {
    if (location.contains(',')) {
      final parts = location.split(',');
      if (parts.length >= 2) {
        try {
          double lat = double.parse(parts[0].trim());
          double lng = double.parse(parts[1].trim());
          return LatLng(lat, lng);
        } catch (e) {
          // في حال فشل التحليل، نعود بنقاط افتراضية
        }
      }
    }
    // في حال عدم توفر إحداثيات صالحة، يتم إرجاع (0,0)
    return const LatLng(0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final LatLng stationLatLng = _parseLocation(widget.location);
    return Container(
      height: 200, // يمكن تعديل الارتفاع حسب الحاجة
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: stationLatLng,
            zoom: 16.0,
          ),
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