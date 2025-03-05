import 'package:flutter/material.dart' hide SearchBar;
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_icons.dart';
import 'package:uot_transport/station_feature/view/widgets/search_bar.dart';
import 'package:uot_transport/station_feature/view/widgets/station_list.dart';

class StationScreen extends StatelessWidget {
  const StationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> stations = [
      {
        'mainTitle': 'محطة 1',
        'subTitle': 'العنوان الفرعي 1',
        'subSubTitle': 'العنوان الفرعي الفرعي 1',
      },
      {
        'mainTitle': 'محطة 2',
        'subTitle': 'العنوان الفرعي 2',
        'subSubTitle': 'العنوان الفرعي الفرعي 2',
      },
      {
        'mainTitle': 'محطة 3',
        'subTitle': 'العنوان الفرعي 3',
        'subSubTitle': 'العنوان الفرعي الفرعي 3',
      },
      {
        'mainTitle': 'محطة 4',
        'subTitle': 'العنوان الفرعي 4',
        'subSubTitle': 'العنوان الفرعي الفرعي 4',
      },
      {
        'mainTitle': 'محطة 5',
        'subTitle': 'العنوان الفرعي 5',
        'subSubTitle': 'العنوان الفرعي الفرعي 5',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(AppIcons.filterIcon),
                const AppText(
                  lbl: 'المحطات',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SearchBar(
     
          ),
          StationList(stations: stations),
          // يمكنك إضافة المزيد من الويدجت هنا
        ],
      ),
    );
  }
}