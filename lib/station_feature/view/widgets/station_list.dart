import 'package:flutter/material.dart';
import 'package:uot_transport/core/app_colors.dart';

class StationList extends StatelessWidget {
  const StationList({super.key, required this.stations});

  final List<Map<String, String>> stations;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: AppColors.primaryColor, width: 1), // إضافة حدود للإطار
              ),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryColor, width: 1), // إضافة حدود للإطار
                  ),
                  child: const Icon(Icons.map, color: AppColors.primaryColor),
                ),
                title: Text(
                  stations[index]['mainTitle']!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      stations[index]['subTitle']!,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: AppColors.textColor),
                    ),
                    Text(
                      stations[index]['subSubTitle']!,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 14, color: AppColors.textColor),
                    ),
                  ],
                ),
                onTap: () {
                  // Handle station tap
                  print('Tapped on ${stations[index]['mainTitle']}');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}