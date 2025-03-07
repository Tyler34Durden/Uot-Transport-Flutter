import 'package:flutter/material.dart';
      import 'package:uot_transport/core/app_colors.dart';
      import 'package:uot_transport/core/core_widgets/uot_appbar.dart';
import 'package:uot_transport/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport/home_feature/view/widgets/city_filter.dart';
import 'package:uot_transport/home_feature/view/widgets/city_filter_item.dart';
      import 'package:uot_transport/home_feature/view/widgets/home_slider.dart';
import 'package:uot_transport/home_feature/view/widgets/my_trips_widget.dart';

      class HomeScreen extends StatelessWidget {
        const HomeScreen({super.key});

        @override
        Widget build(BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeSlider(),
                    const SizedBox(height: 20),
                    const Text(
                      "رحلاتي:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  const SizedBox(height: 25),
                  const MyTripsWidget(),
                  const SizedBox(height: 10),
                  const MyTripsWidget(),
                  const SizedBox(height: 20),
                  const Text(
                    "رحلات اليوم:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 25),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: const [
                          CityFilterItem(
                            title: 'All',
                            isSelected: true,
                          ),
                          CityFilterItem(
                            title: 'Baghdad',
                            isSelected: false,
                          ),
                          CityFilterItem(
                            title: 'Erbil',
                            isSelected: false,
                          ),
                          CityFilterItem(
                            title: 'Sulaymaniyah',
                            isSelected: false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const ActiveTripsWidget(),

                  ],
                ),
              ),
            ),
          );
        }
      }