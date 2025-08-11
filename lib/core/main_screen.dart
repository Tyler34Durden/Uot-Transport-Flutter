import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/app_icons.dart';
import 'package:uot_transport/core/core_widgets/uot_appbar.dart';
import 'package:uot_transport/home_feature/view/screens/home_screen.dart';
import 'package:uot_transport/profile_feature/model/repository/profile_repository.dart';
import 'package:uot_transport/profile_feature/view/screens/profile_screen.dart';
import 'package:uot_transport/station_feature/model/repository/stations_repository.dart';
import 'package:uot_transport/station_feature/view/screens/station_screen.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_cubit.dart';
import 'package:uot_transport/trips_feature/view/screens/trips_screen.dart';
import 'dart:io' show Platform;
import 'package:uot_transport/auth_feature/view/screens/login_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 3;
  final PageController _pageController = PageController(initialPage: 3);

  // Global navigator key for accessing navigation from anywhere
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Logger instance
  final Logger _logger = Logger();

  // متغيرات للتوكن ومعرف المستخدم
  String? _token;
  int? _userId;

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // دالة لتحميل التوكن ومعرف المستخدم من SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token') ?? '';
      _userId = prefs.getInt('user_id') ?? 0; // مثلاً 0 كقيمة افتراضية
    });
    _logger.i('Loaded token: $_token, userId: $_userId');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _logger.i('Navigation tapped, index: $index');
    _pageController.jumpToPage(index);
  }

  // Process logout and credentials clearing
  Future<void> _handleLogout() async {
    try {
      // Call logout API
      final profileRepo = ProfileRepository();
      await profileRepo.logout(_token ?? '');
      _logger.i('Logout successful');

      // Clear stored credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      _logger.i('Credentials cleared from storage');
    } catch (e) {
      _logger.e('Error during logout: $e');

      // Still clear credentials even on API error
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button navigation
      onWillPop: () async {
        // Show exit confirmation dialog
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'هل تريد الخروج من التطبيق؟',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'سيتم تسجيل الخروج عند الضغط على نعم',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ElevatedButton(
                      onPressed: () async {
                        // First get the MaterialApp's navigator before dismissing dialog
                        final navigator = Navigator.of(context);

                        // Dismiss the dialog first
                        navigator.pop(false);

                        // Handle logout operations
                        await _handleLogout();

                        // Navigate to login screen using a new route
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                              (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: AppColors.backgroundColor,
                        minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.7,
                            MediaQuery.of(context).size.height * 0.06
                        ),
                      ),
                      child: const Text("نعم"),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: AppColors.primaryColor,
                        minimumSize: Size(double.infinity, MediaQuery.of(context).size.height * 0.06),
                      ),
                      child: const Text("لا"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        appBar: UotAppbar(),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _logger.i('Page changed to index: $index');
          },
          // إزالة const ليتم تمرير المتغيرات للديناميكية
          children: [
            BlocProvider(
              create: (_) => StationsCubit(StationsRepository())..fetchStations(),
              child: const StationScreen(),
            ),
            const TripsScreen(),
            ProfileScreen(token: _token ?? '', userId: _userId ?? 0),
            const HomeScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 56,
          color: AppColors.primaryColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double widthPerItem = constraints.maxWidth / 4;
              // Recalculate underline's left position for new width (40) and center it.
              double underlineLeft =
                  widthPerItem * _selectedIndex + (widthPerItem - 40) / 2;

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
      ),
    );
  }
}