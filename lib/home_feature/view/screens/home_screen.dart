import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport/home_feature/view/widgets/home_slider.dart';
import 'package:uot_transport/home_feature/view/widgets/my_trips_widget.dart';
import 'package:uot_transport/home_feature/view/widgets/station_filters.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_cubit.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_state.dart';
import 'package:uot_transport/home_feature/view_model/cubit/home_station_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedStationId;
  String? token;
  final ScrollController _tripsScrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initializeToken();
    _tripsScrollController.addListener(_onTripsScroll);
  }

  @override
  void dispose() {
    _tripsScrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    if (token != null) {
      context.read<HomeStationCubit>().fetchStations(token!);
      context.read<HomeStationCubit>().fetchMyTrips(token!);
      context.read<TripsCubit>().fetchTripsByStations(loadMore: false, token: token!);
    } else {
      debugPrint('Token not found. Redirecting to login...');
    }
  }

  void _onTripsScroll() {
    final cubit = context.read<TripsCubit>();
    if (_tripsScrollController.position.pixels >=
        _tripsScrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        cubit.state is TripsLoaded) {
      setState(() => _isLoadingMore = true);
      cubit
          .fetchTripsByStations(
        startStationId: selectedStationId?.toString(),
        loadMore: true,
        token: token!,
      )
          .whenComplete(() {
        if (mounted) setState(() => _isLoadingMore = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final padding = width * 0.04;
    final titleFontSize = width * 0.05; // Responsive font size
    final sectionSpacing = height * 0.03;
    final itemSpacing = height * 0.015;

    final stations = context.watch<HomeStationCubit>().state.stations;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: RefreshIndicator(
          onRefresh: () async {
            if (token != null) {
              await context.read<HomeStationCubit>().fetchStations(token!);
              await context.read<HomeStationCubit>().fetchMyTrips(token!);
              await context.read<TripsCubit>().fetchTripsByStations(loadMore: false, token: token!);
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // My Trips Section
                  Text(
                    "رحلاتي:",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  BlocBuilder<HomeStationCubit, HomeStationState>(
                    builder: (context, state) {
                      if (state.isFetchMyTripsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.fetchMyTripsError != null) {
                        return Center(child: Text('لم تقم بحجز رحلات بعد', style: TextStyle(fontSize: width * 0.04)));
                      } else if (state.myTrips.isNotEmpty) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.myTrips.length,
                          itemBuilder: (context, index) {
                            final trip = state.myTrips[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: itemSpacing),
                              child: MyTripsWidget(trip: trip),
                            );
                          },
                        );
                      }
                      return Center(child: Text('No trips available.', style: TextStyle(fontSize: width * 0.04)));
                    },
                  ),
                  SizedBox(height: sectionSpacing),

                  // Today's Trips Section with Pagination
                  Text(
                    "رحلات اليوم:",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                  BlocBuilder<TripsCubit, TripsState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StationFilters(
                            selectedStationId: selectedStationId,
                            stations: stations,
                            onStationSelected: (stationId) {
                              setState(() {
                                selectedStationId = stationId;
                              });
                              context.read<TripsCubit>().fetchTripsByStations(
                                startStationId: stationId?.toString(),
                                loadMore: false,
                                token: token!,
                              );
                            },
                          ),
                          SizedBox(height: itemSpacing),
                          if (state is TripsLoading && !_isLoadingMore)
                            const Center(child: CircularProgressIndicator())
                          else if (state is TripsError)
                            Center(child: Text('لا توجد رحلات متجهة إلى تلك المحطة.', style: TextStyle(fontSize: width * 0.04)))
                          else if (state is TripsLoaded && state.trips.isNotEmpty)
                              Column(
                                children: [
                                  ListView.builder(
                                    controller: _tripsScrollController,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.trips.length,
                                    itemBuilder: (context, index) {
                                      final trip = state.trips[index];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: itemSpacing),
                                        child: ActiveTripsWidget(
                                          busId: trip['busId'].toString(),
                                          tripId: trip['tripId'].toString(),
                                          tripState: trip['tripState'],
                                          firstTripRoute: trip['firstTripRoute'] ?? {},
                                          lastTripRoute: trip['lastTripRoute'] ?? {},
                                        ),
                                      );
                                    },
                                  ),
                                  if (_isLoadingMore)
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: itemSpacing),
                                      child: const Center(child: CircularProgressIndicator()),
                                    ),
                                ],
                              )
                            else
                              Center(child: Text('No trips available.', style: TextStyle(fontSize: width * 0.04))),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}