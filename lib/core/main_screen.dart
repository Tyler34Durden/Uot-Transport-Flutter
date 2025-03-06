import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_icons.dart';
import 'package:uot_transport/core/core_widgets/uot_appbar.dart';
import 'package:uot_transport/home_feature/view/screens/home_screen.dart';
import 'package:uot_transport/profile_feature/view/screens/profile_screen.dart';
import 'package:uot_transport/station_feature/view/screens/station_screen.dart';
import 'package:uot_transport/trips_feature/view/screens/trips_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 3;
  final PageController _pageController = PageController(initialPage: 3);

  // Lists for the icon paths
  final List<String> selectedIcons = [
    AppIcons.solid_StationNavPath,
    AppIcons.solid_TripsNavPath,
    AppIcons.solid_ProfileNavPath,
    AppIcons.solid_HomeNavPath,
  ];

  final List<String> unselectedIcons = [
    AppIcons.outline_StationNavPath,
    AppIcons.outline_TripsNavPath,
    AppIcons.outline_ProfileNavPath,
    AppIcons.outline_HomeNavPath,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UotAppbar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          StationScreen(),
          TripsScreen(),
          ProfileScreen(),
          HomeScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 56,
        color: AppColors.primaryColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double widthPerItem = constraints.maxWidth / 4;
            // Recalculate underline's left position for new width (40) and center it.
            double underlineLeft = widthPerItem * _selectedIndex + (widthPerItem - 40) / 2;

            return Stack(
              children: [
                // Underline widget with a wider, rounder half-circle appearance.
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  left: underlineLeft,
                  bottom: 0,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                // Navigation icons row.
                Row(
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onItemTapped(index),
                        child: Center(
                          child: SvgPicture.asset(
                            _selectedIndex == index
                                ? selectedIcons[index]
                                : unselectedIcons[index],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}