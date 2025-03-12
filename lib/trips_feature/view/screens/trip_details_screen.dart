import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/trips_feature/view/widgets/bus_tracking_widget.dart';
import 'package:uot_transport/trips_feature/view/widgets/departure_arrival_widget.dart';
import 'package:uot_transport/trips_feature/view/widgets/trip_header_options.dart';

class TripDetailsScreen extends StatelessWidget {
  final String tripName;

  const TripDetailsScreen({super.key, required this.tripName});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BackHeader(),
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppText(
                lbl: ' الرحلة: $tripName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const TripHeaderOptions(),
              const DepartureArrivalWidget(),
              const SizedBox(height: 20),
              const AppText(
                lbl: 'مسار الحافلة:',
                style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Expanded(
                child: BusTrackingWidget(
                  stations: [
                    'محطة جنة العريف بجوار كافي لاتي',
                    'محطة جنة العريف بجوار كافي لاتي',
                    'محطة جنة العريف بجوار كافي لاتي',
                    'محطة جنة العريف بجوار كافي لاتي'
                  ],
                  currentStationIndex: 0, // مثال على المحطة الحالية
                ),
              ),
            AppButton(lbl: 'حجز الرحلة', onPressed: () {
              
            }),
              
            ],
          ),
        ),
      ),
    );
  }
}
