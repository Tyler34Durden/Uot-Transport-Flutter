import 'package:flutter/material.dart';
    import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
    import 'package:uot_transport/core/app_colors.dart';
    import 'package:uot_transport/home_feature/view/widgets/active_trips_widget.dart';
    import 'package:uot_transport/trips_feature/view/widgets/trip_selection_widget.dart';

    class TripsScreen extends StatelessWidget {
      const TripsScreen({super.key});

      @override
      Widget build(BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 28, right: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        lbl: 'الرحلات',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                TripSelectionWidget(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ActiveTripsWidget(
                    tripId: '1001#',
                    tripState: 'Active',
                    firstTripRoute: {
                      'stationName': 'Station A',
                      'expectedTime': '12:00 PM',
                    },
                    lastTripRoute: {
                      'stationName': 'Station Z',
                      'expectedTime': '1:00 PM',
                    }, busId: '1001',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ActiveTripsWidget(
                    tripId: '1002#',
                    tripState: 'Inactive',
                    firstTripRoute: {
                      'stationName': 'Station B',
                      'expectedTime': '1:30 PM',
                    },
                    lastTripRoute: {
                      'stationName': 'Station Y',
                      'expectedTime': '2:30 PM',
                    }, busId: '',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ActiveTripsWidget(
                    tripId: '1003#',
                    tripState: 'Active',
                    firstTripRoute: {
                      'stationName': 'Station C',
                      'expectedTime': '3:00 PM',
                    },
                    lastTripRoute: {
                      'stationName': 'Station X',
                      'expectedTime': '4:00 PM',
                    }, busId: '',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ActiveTripsWidget(
                    tripId: '1004#',
                    tripState: 'Inactive',
                    firstTripRoute: {
                      'stationName': 'Station D',
                      'expectedTime': '5:00 PM',
                    },
                    lastTripRoute: {
                      'stationName': 'Station W',
                      'expectedTime': '6:00 PM',
                    }, busId: '',
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }