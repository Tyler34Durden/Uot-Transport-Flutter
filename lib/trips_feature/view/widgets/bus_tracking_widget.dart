import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_icons.dart';

class BusTrackingWidget extends StatelessWidget {
  final List<Map<String, dynamic>> stations;

  const BusTrackingWidget({
    super.key,
    required this.stations,
  });

  @override
  Widget build(BuildContext context) {
    final lastReachedIndex = stations.lastIndexWhere((s) => s['state'] == 'Reached');

    return Column(
      children: [
        const SizedBox(height: 10),
        Column(
          children: List.generate(stations.length, (index) {
            final station = stations[index];
            final isReached = station['state'] == 'Reached';
            final isLastReached = index == lastReachedIndex && isReached;
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          if (index != 0)
                            Container(
                              width: 4,
                              height: 40,
                              color: AppColors.primaryColor,
                            ),
                          SvgPicture.asset(
                            isReached
                                ? AppIcons.filled_pin
                                : AppIcons.outline_pin,
                          ),
                          if (index != stations.length - 1)
                            Container(
                              width: 4,
                              height: 40,
                              color: AppColors.primaryColor,
                            ),
                        ],
                      ),
                      if (isLastReached)
                        Positioned(
                          right: -25, // adjust as needed
                          top: 45, // adjust to vertically center with pin
                          child: Icon(
                            Icons.directions_bus_filled_outlined,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 24), // more space for the bus icon
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station['stationName'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          station['time'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}