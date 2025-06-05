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
    token = prefs.getString('auth_token');
    if (token != null) {
      context.read<HomeStationCubit>().fetchStations();
      context.read<HomeStationCubit>().fetchMyTrips(token!);
      // Initial fetch for today's trips (first page)
      context.read<TripsCubit>().fetchTripsByStations(loadMore: false);
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
          )
          .whenComplete(() {
        if (mounted) setState(() => _isLoadingMore = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stations = context.watch<HomeStationCubit>().state.stations;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // My Trips Section
                const Text(
                  "رحلاتي:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 25),
                BlocBuilder<HomeStationCubit, HomeStationState>(
                  builder: (context, state) {
                    if (state.isFetchMyTripsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.fetchMyTripsError != null) {
                      return Center(child: Text
                        ('لم تقم بحجز رحلات بعد'));
                    } else if (state.myTrips.isNotEmpty) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.myTrips.length,
                        itemBuilder: (context, index) {
                          final trip = state.myTrips[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: MyTripsWidget(trip: trip),
                          );
                        },
                      );
                    }
                    return const Center(child: Text('No trips available.'));
                  },
                ),
                const SizedBox(height: 20),

                // Today's Trips Section with Pagination
                const Text(
                  "رحلات اليوم:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 25),
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
                            // Reset pagination and fetch new trips for the selected station
                            context.read<TripsCubit>().fetchTripsByStations(
                              startStationId: stationId?.toString(),
                              loadMore: false,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        if (state is TripsLoading && !_isLoadingMore)
                          const Center(child: CircularProgressIndicator())
                        else if (state is TripsError)
                          Center(child: Text('لا توجد رحلات متجهة إلى تلك المحطة.'))
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
                                    padding: const EdgeInsets.only(bottom: 16.0),
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
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                            ],
                          )
                        else
                          const Center(child: Text('No trips available.')),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}