import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_icons.dart';

class BusTrackingWidget extends StatelessWidget {
  final List<String> stations;
  final int currentStationIndex;

  const BusTrackingWidget({
    super.key,
    required this.stations,
    required this.currentStationIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Column(
          children: List.generate(stations.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 16.0), // إضافة بادينق من اليمين
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      if (index != 0)
                        Container(
                          width: 4,
                          height: 40,
                          color: AppColors.primaryColor,
                        ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            index <= currentStationIndex
                                ? AppIcons.solid_ProfileNavPath // صورة الموقع في حالة تتبع الحافلة
                                : AppIcons.outline_ProfileNavPath, // صورة الموقع في حالة عدم تتبع الحافلة
                          ),
                          if (index == currentStationIndex)
                            SvgPicture.asset(AppIcons.outline_TripsNavPath), // صورة الحافلة
                        ],
                      ),
                      if (index != stations.length - 1)
                        Container(
                          width: 4,
                          height: 40,
                          color: AppColors.primaryColor,
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stations[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: index <= currentStationIndex
                                ? AppColors.primaryColor
                                : AppColors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          '7:30 صباحًا',
                          style: TextStyle(
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