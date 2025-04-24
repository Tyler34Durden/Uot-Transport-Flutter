
import 'package:flutter/material.dart';
import 'package:uot_transport/home_feature/view/widgets/city_filter_item.dart';

class StationFilters extends StatelessWidget {
  final int? selectedStationId;
  final Function(int?) onStationSelected;
  final List<Map<String, dynamic>> stations;

  const StationFilters({
    Key? key,
    required this.selectedStationId,
    required this.onStationSelected,
    required this.stations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          CityFilterItem(
            title: "الكل",
            isSelected: selectedStationId == null,
            onTap: () => onStationSelected(null),
          ),
          ...stations.map<Widget>((station) {
            final stationId = station['id'];
            final stationName = station['stationName'] ?? 'Unknown Station';
            return CityFilterItem(
              key: ValueKey(stationId),
              title: stationName,
              isSelected: selectedStationId == stationId,
              onTap: () => onStationSelected(stationId),
            );
          }).toList(),
        ],
      ),
    );
  }
}