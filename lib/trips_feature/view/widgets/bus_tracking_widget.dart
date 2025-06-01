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
        return Column(
          children: [
            const SizedBox(height: 10),
            Column(
              children: List.generate(stations.length, (index) {
                final station = stations[index];
                final isReached = station['state'] == 'Reached';
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
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
                                isReached
                                    ? AppIcons.filled_pin
                                    : AppIcons.outline_pin,
                              ),
                              if (isReached)
                                SvgPicture.asset(AppIcons.bustracking),
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
                              station['stationName'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
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