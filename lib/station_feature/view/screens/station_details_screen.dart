import 'package:flutter/material.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport/station_feature/view/widgets/google_map_widget.dart';

class StationDetailsScreen extends StatelessWidget {
  final Map<String, String> station;

  const StationDetailsScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const BackHeader(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GoogleMapWidget(), 
const SizedBox(height: 20),
              AppText(
                lbl: station['mainTitle']!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const AppText(
                lbl: 'الرحلات :',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
            // const ActiveTripsWidget(tripName:'1001#'),

              const SizedBox(height: 10),

            // const ActiveTripsWidget(tripName:'1002#'),
              const SizedBox(height: 10),

              const SizedBox(height: 10),
              const AppText(
                lbl: 'الرحلات القادمة:',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

            // const ActiveTripsWidget(tripName:'1003#'),
            ],
          ),
        ),
      ),
    );
  }
}
