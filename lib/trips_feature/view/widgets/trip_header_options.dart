import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/trips_feature/view/widgets/departure_arrival_widget.dart';
import 'package:uot_transport/trips_feature/view/widgets/trip_squre_tile.dart';

class TripHeaderOptions extends StatelessWidget {
  const TripHeaderOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TripSqureTile(
            label: 'المقاعد',
            icon: Icons.chair_alt_rounded,
            iconColor: AppColors.primaryColor,
            onTap: () {},
          ),
          TripSqureTile(
            label: 'الركاب',
            icon: Icons.people_outlined,
            iconColor: AppColors.primaryColor,
            onTap: () {},
          ),
          TripSqureTile(
            label: 'الحافلة ',
            icon: Icons.bus_alert,
            iconColor: AppColors.primaryColor,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
