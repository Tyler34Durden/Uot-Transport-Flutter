import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/features/home_feature/domain/entities/home_trip_entity.dart';
import 'package:uot_transport/features/trips_feature/presentation/pages/my_trip_details_screen.dart';

class MyTripsWidget extends StatelessWidget {
  const MyTripsWidget({super.key, required this.trip});

  final HomeTripEntity trip;

  Future<void> _openDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyTripDetailsScreen(
          tripId: trip.tripId.toString(),
          busId: trip.busId.toString(),
          tripState: trip.tripState?.toString() ?? '',
          firstTripRoute: trip.firstTripRoute,
          lastTripRoute: trip.lastTripRoute,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const SizedBox(width: 5),
            SvgPicture.asset('assets/icons/bus.svg'),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الحافلة ${trip.busId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        _truncateText('${trip.firstTripRoute['stationName']}', 8),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset('assets/icons/arrow-right-circle.svg'),
                      const SizedBox(width: 5),
                      Text(
                        _truncateText('${trip.lastTripRoute['stationName']}', 8),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${trip.firstTripRoute['expectedTime'] ?? '--:--'} - ${trip.lastTripRoute['expectedTime'] ?? '--:--'}',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
  }
}
