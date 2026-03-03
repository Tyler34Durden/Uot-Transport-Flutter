import 'package:flutter/material.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';

import 'city_filter_item.dart';

class StationFilters extends StatelessWidget {
  final int? selectedStationId;
  final ValueChanged<int?> onStationSelected;
  final List<StationEntity> stations;

  const StationFilters({
    super.key,
    required this.selectedStationId,
    required this.onStationSelected,
    required this.stations,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          CityFilterItem(
            title: 'الكل',
            isSelected: selectedStationId == null,
            onTap: () => onStationSelected(null),
          ),
          ...stations.map<Widget>((station) {
            return CityFilterItem(
              key: ValueKey(station.id),
              title: station.name,
              isSelected: selectedStationId == station.id,
              onTap: () => onStationSelected(station.id),
            );
          }),
        ],
      ),
    );
  }
}
