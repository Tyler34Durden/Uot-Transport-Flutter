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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedStationId;
  String? token;

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token'); // Retrieve the token
    if (token != null) {
      context.read<HomeStationCubit>().fetchStations();
      context.read<HomeStationCubit>().fetchTodayTrips();
      context.read<HomeStationCubit>().fetchMyTrips(token!); // Use the token
    } else {
      // Handle the case where the token is null (e.g., redirect to login)
      debugPrint('Token not found. Redirecting to login...');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // Advertisings Section
                BlocBuilder<AdvertisingsCubit, AdvertisingsState>(
                  builder: (context, state) {
                    if (state is AdvertisingsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AdvertisingsLoaded) {
                      final advertisings =
                      state.advertisings.cast<Map<String, dynamic>>();
                      return HomeSlider(advertisings: advertisings);
                    } else if (state is AdvertisingsError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),

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
                      return Center(child: Text('Error: ${state.fetchMyTripsError}'));
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

                // Today's Trips Section
                const Text(
                  "رحلات اليوم:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 25),
                BlocBuilder<HomeStationCubit, HomeStationState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StationFilters(
                          selectedStationId: selectedStationId,
                          stations: state.stations,
                          onStationSelected: (stationId) {
                            setState(() {
                              selectedStationId = stationId;
                            });
                            context
                                .read<HomeStationCubit>()
                                .fetchTodayTrips(stationId: stationId);
                          },
                        ),
                        const SizedBox(height: 20),
                        if (state.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (state.error != null)
                          Center(child: Text('Error: ${state.error}'))
                        else if (state.trips.isNotEmpty)
                            ListView.builder(
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