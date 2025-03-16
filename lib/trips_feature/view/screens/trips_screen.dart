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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 28, right: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
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
                  const TripSelectionWidget(),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: ActiveTripsWidget(tripName: '1001#'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: ActiveTripsWidget(tripName: '1002#'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: ActiveTripsWidget(tripName: '1003#'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: ActiveTripsWidget(tripName: '1004#'),
                  ),
                ],
              ),
            ),
          );
        }
      }