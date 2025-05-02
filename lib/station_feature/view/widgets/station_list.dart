//after removed added again
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/station_feature/view/screens/station_details_screen.dart';
import 'package:uot_transport/station_feature/view/widgets/google_map_widget.dart';

class StationList extends StatelessWidget {
  const StationList({super.key, required this.stations});

  final List<dynamic> stations;

  @override
  Widget build(BuildContext context) {
    final logger = Logger();

    if (stations.isEmpty) {
      return const Center(child: Text('لا توجد محطات متاحة حالياً'));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          logger.i('Item at index $index: ${stations[index]}');

          if (stations[index] is! Map) {
            logger.e('Invalid station data format at index $index');
            return const Text('Invalid station data format');
          }

          final station = stations[index]['station'];
          final nearestTrip = stations[index]['nearestTrip'];

          if (station == null) {
            logger.e('Station data is missing at index $index');
            return const Text('Station data is missing');
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: AppColors.primaryColor, width: 1),
              ),
              child: ListTile(
                leading: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryColor, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:   GoogleMapWidget(
                      location: station['location'] ?? '0.0,0.0', // Pass the location here
                    ),
                  ),
                ),
                title: Text(
                  station['name'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      station['location'] ?? 'Unknown location',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: AppColors.textColor),
                    ),
                    Text(
                      nearestTrip != null && nearestTrip['firstTripRoute'] != null
                          ? 'Next Trip: ${nearestTrip['firstTripRoute']['expectedTime']}'
                          : 'No trips available',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: AppColors.textColor),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StationDetailsScreen(station: station)),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}