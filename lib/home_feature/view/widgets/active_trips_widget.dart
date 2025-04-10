import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/trips_feature/view/screens/trip_details_screen.dart';


  class ActiveTripsWidget extends StatelessWidget {
    final String busId;
    final String tripId;
    final String tripState;
    final Map<String, dynamic> firstTripRoute;
    final Map<String, dynamic> lastTripRoute;

    const ActiveTripsWidget({
      super.key,
      required this.busId,
      required this.tripId,
      required this.tripState,
      required this.firstTripRoute,
      required this.lastTripRoute,
    });

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TripDetailsScreen(tripId: tripId),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 5),
              SvgPicture.asset('assets/icons/bus.svg'),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' الحافلة ${_truncateText(busId.toString(), 15)}', // Convert busId to String
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        Text('${firstTripRoute['expectedTime']}'),
                        Text(' - '),
                        Text('${lastTripRoute['expectedTime']}'),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        Text(
                          _truncateText('${firstTripRoute['stationName']}', 8),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SvgPicture.asset(
                          'assets/icons/arrow-right-circle.svg',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _truncateText('${lastTripRoute['stationName']}', 8),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 15),
                  AppButton(
                    lbl: "حجز",
                    onPressed: () {
                      _showStationDialog(context);
                    },
                    color: AppColors.secondaryColor,
                    textColor: AppColors.primaryColor,
                    width: 92,
                    height: 36,
                  ),
                ],
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
      );
    }

    String _truncateText(String text, int maxLength) {
      return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
    }

    void _showStationDialog(BuildContext context) {
      // Dialog implementation remains unchanged
    }
  }