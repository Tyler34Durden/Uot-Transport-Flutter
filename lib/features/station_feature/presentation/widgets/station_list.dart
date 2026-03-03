import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';
import 'package:uot_transport/features/station_feature/presentation/pages/station_details_screen.dart';

class StationList extends StatelessWidget {
  const StationList({
    super.key,
    required this.stations,
    this.controller,
  });

  final List<StationEntity> stations;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return const Center(child: Text('لا توجد محطات متاحة حالياً'));
    }

    return ListView.builder(
      controller: controller,
      itemCount: stations.length,
      itemBuilder: (context, index) {
        final station = stations[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            color: AppColors.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: AppColors.primaryColor, width: 1),
            ),
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined, color: AppColors.primaryColor),
              title: Text(
                station.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
              subtitle: Text(
                station.location,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 14, color: AppColors.textColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StationDetailsScreen(
                      args: StationDetailsArgs(
                        id: station.id,
                        name: station.name,
                        location: station.location,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

