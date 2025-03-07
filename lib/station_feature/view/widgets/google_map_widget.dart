// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleMapWidget extends StatefulWidget {
//   final double latitude;
//   final double longitude;

//   const GoogleMapWidget({super.key, required this.latitude, required this.longitude});

//   @override
//   _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
// }

// class _GoogleMapWidgetState extends State<GoogleMapWidget> {
//   late GoogleMapController mapController;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: double.infinity,
//       child: GoogleMap(
//         onMapCreated: (controller) {
//           mapController = controller;
//         },
//         initialCameraPosition: CameraPosition(
//           target: LatLng(widget.latitude, widget.longitude),
//           zoom: 14.0,
//         ),
//         markers: {
//           Marker(
//             markerId: MarkerId('station_location'),
//             position: LatLng(widget.latitude, widget.longitude),
//           ),
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late GoogleMapController mapController;
//! تغير الاحداثيات ل متغير بدلا من ثوابت 
  final LatLng _center = const LatLng(32.856428, 13.222432); 

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color:  Colors.grey, 
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10), 
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), 
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('station_location'),
              position: _center,
            ),
          },
        ),
      ),
    );
  }
}