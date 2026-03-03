import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/core/core_widgets/uot_appbar.dart';
import 'package:uot_transport/features/notifications_feature/presentation/cubit/notifications_cubit.dart';
import 'package:uot_transport/features/profile_feature/presentation/cubit/profile_cubit.dart';
import 'package:uot_transport/features/profile_feature/presentation/pages/profile_screen.dart' as clean_profile;
import 'package:uot_transport/features/profile_feature/domain/usecases/logout_usecase.dart';
import 'package:uot_transport/features/auth_feature/presentation/cubit/auth_cubit.dart' as clean;
import 'package:uot_transport/features/auth_feature/presentation/screens/login_screen.dart' as clean;
import 'package:uot_transport/core/locator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/core/app_colors.dart';

// Remove legacy trips imports

// Replace legacy station imports with clean ones
import 'package:uot_transport/features/station_feature/presentation/pages/station_screen.dart' as station_page;
import 'package:uot_transport/features/station_feature/presentation/cubit/stations_cubit.dart' as station_cubit;
import 'package:uot_transport/features/station_feature/presentation/cubit/station_trips_cubit.dart'
    as station_trips_cubit;
import 'package:uot_transport/features/home_feature/presentation/pages/home_screen.dart' as clean_home;
import 'package:uot_transport/features/trips_feature/presentation/pages/trips_screen.dart' as clean_trips;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 3;
  final PageController _pageController = PageController(initialPage: 3);

  // Logger instance
  final Logger _logger = Logger();

  // متغيرات للتوكن ومعرف المستخدم
  String? _token;
  int? _userId;

  // Lists for the icon paths
  final List<String> selectedIcons = [
    'assets/icons/heroicons-solid/map.svg',
    'assets/icons/heroicons-solid/calendar-days.svg',
    'assets/icons/heroicons-solid/user.svg',
    'assets/icons/heroicons-solid/home.svg',
  ];

  final List<String> unselectedIcons = [
    'assets/icons/heroicons-outline/map.svg',
    'assets/icons/heroicons-outline/calendar-days.svg',
    'assets/icons/heroicons-outline/user.svg',
    'assets/icons/heroicons-outline/home.svg',
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
      await getIt<LogoutUseCase>()();
      _logger.i('Logout handled');
    } catch (e) {
      _logger.e('Error during logout: $e');
      // best-effort clear; usecase should already clear
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationsCubit>(create: (_) => getIt<NotificationsCubit>()),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
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
                      color: Theme.of(context).primaryColor,
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
                              MaterialPageRoute(
                                builder: (_) => BlocProvider<clean.AuthCubit>(
                                  create: (_) => getIt<clean.AuthCubit>(),
                                  child: clean.LoginScreen(),
                                ),
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
            // If user confirms exit, handle logout and navigation
            if (shouldExit == true) {
              await _handleLogout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<clean.AuthCubit>(
                    create: (_) => getIt<clean.AuthCubit>(),
                    child: clean.LoginScreen(),
                  ),
                ),
                (route) => false,
              );
            }
          }
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
            children: [
              MultiBlocProvider(
                providers: [
                  BlocProvider<station_cubit.StationsCubit>(
                    create: (_) => getIt<station_cubit.StationsCubit>(),
                  ),
                  BlocProvider<station_trips_cubit.StationTripsCubit>(
                    create: (_) => getIt<station_trips_cubit.StationTripsCubit>(),
                  ),
                ],
                child: station_page.StationScreen(),
              ),
              clean_trips.TripsScreen(token: _token ?? ''),
              // Replace legacy ProfileScreen
              BlocProvider<ProfileCubit>(
                create: (_) => getIt<ProfileCubit>(),
                child: const clean_profile.ProfileScreen(),
              ),
              const clean_home.CleanHomeScreen(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Builder(
              builder: (context) {
                final bottomInset = MediaQuery.of(context).padding.bottom;
                final extra = bottomInset == 0 ? 12.0 : bottomInset; // ensure some spacing even if inset 0
                return Container(
                  height: 56 + extra,
                  padding: EdgeInsets.only(bottom: extra),
                  color: AppColors.primaryColor,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double widthPerItem = constraints.maxWidth / 4;
                      double underlineLeft =
                          widthPerItem * _selectedIndex + (widthPerItem - 40) / 2;

                      return Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            left: underlineLeft,
                            bottom: extra - 4, // keep underline just above padding
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.accentColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Row(
                                children: List.generate(4, (index) {
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => _onItemTapped(index),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          _selectedIndex == index
                                              ? selectedIcons[index]
                                              : unselectedIcons[index],
                                          width: 26,
                                          height: 26,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                          placeholderBuilder: (_) => Icon(
                                            [Icons.directions_bus, Icons.route, Icons.person, Icons.home][index],
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
