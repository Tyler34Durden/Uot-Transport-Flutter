import 'package:flutter/material.dart';
    import 'package:uot_transport/core/app_colors.dart';
    import 'package:uot_transport/trips_feature/view/widgets/departure_arrival_widget.dart';
    import 'package:uot_transport/trips_feature/view/widgets/trip_squre_tile.dart';

    class TripHeaderOptions extends StatelessWidget {
      final Map<String, dynamic> tripData;
      const TripHeaderOptions({
        super.key,
        required this.tripData,
      });

      @override
      Widget build(BuildContext context) {
        final Map<String, dynamic> bus = tripData['bus'] ?? {};
        final Map<String, dynamic> booking = tripData['booking'] ?? {};
        final int numberOfSeats = bus['numberOfSeats'] ?? 0;
        final int male = booking['male'] ?? 0;
        final int female = booking['female'] ?? 0;
        final int totalPassengers = male + female;
        final String busId = bus['id']?.toString() ?? '';

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
                label: 'المقاعد: $numberOfSeats',
                icon: Icons.chair_alt_rounded,
                iconColor: AppColors.primaryColor,
                onTap: () {},
              ),
              TripSqureTile(
                label: 'الركاب: $totalPassengers',
                icon: Icons.people_outlined,
                iconColor: AppColors.primaryColor,
                onTap: () {},
              ),
              TripSqureTile(
                label: 'الحافلة $busId',
                icon: Icons.bus_alert,
                iconColor: AppColors.primaryColor,
                onTap: () {},
              ),
            ],
          ),
        );
      }
    }