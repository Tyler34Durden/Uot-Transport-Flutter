import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport/station_feature/view/widgets/google_map_widget.dart';
import 'package:uot_transport/station_feature/model/repository/station_trips_repository.dart';
import 'package:uot_transport/station_feature/view_model/cubit/station_trips_cubit.dart';
import 'package:uot_transport/station_feature/view_model/cubit/station_trips_state.dart';

class StationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> station;
  const StationDetailsScreen({super.key, required this.station});

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    final int stationId = widget.station['id'];
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const BackHeader(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.3,
                  child: GoogleMapWidget(
                    location: widget.station['location'] ?? '0.0,0.0',
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                AppText(
                  lbl: widget.station['name']?.toString() ?? 'No Title',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                const AppText(
                  lbl: 'الرحلات :',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),
                // Split trips into active and soon
                if (token != null)
                  BlocProvider(
                    create: (context) => StationTripsCubit(StationTripsRepository())
                      ..fetchStationTrips(stationId, token!),
                    child: BlocBuilder<StationTripsCubit, StationTripsState>(
                      builder: (context, state) {
                        if (state is StationTripsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is StationTripsFailure) {
                          final isNoRouteToHost = state.error.toString().contains('No route to host');
                          if (isNoRouteToHost) {
                            return Center(
                              child: Text(
                                'لا يوجد اتصال بالخادم',
                                style: TextStyle(fontSize: screenWidth * 0.045, color: AppColors.primaryColor),
                              ),
                            );
                          }
                          return Center(child: Text('Error: ${state.error}'));
                        } else if (state is StationTripsSuccess) {
                          final trips = state.trips;
                          final activeTrips = trips.where((trip) => trip['tripState'] == 'active').toList();
                          if (activeTrips.isEmpty) {
                            return const Center(child: Text('لا توجد رحلات حاليا'));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: activeTrips.length,
                            itemBuilder: (context, index) {
                              final trip = activeTrips[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                                child: ActiveTripsWidget(
                                  busId: trip['busId']?.toString() ?? '',
                                  tripId: trip['tripId']?.toString() ?? '',
                                  tripState: trip['tripState']?.toString() ?? 'unknown',
                                  firstTripRoute: trip['firstTripRoute'] ?? {},
                                  lastTripRoute: trip['lastTripRoute'] ?? {},
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  )
                else
                  const Center(child: CircularProgressIndicator()),
                SizedBox(height: screenHeight * 0.01),
                const AppText(
                  lbl: 'الرحلات القادمة:',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                if (token != null)
                  BlocProvider(
                    create: (context) => StationTripsCubit(StationTripsRepository())
                      ..fetchStationTrips(stationId, token!),
                    child: BlocBuilder<StationTripsCubit, StationTripsState>(
                      builder: (context, state) {
                        if (state is StationTripsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is StationTripsFailure) {
                          final isNoRouteToHost = state.error.toString().contains('No route to host');
                          if (isNoRouteToHost) {
                            return Center(
                              child: Text(
                                'لا يوجد اتصال بالخادم',
                                style: TextStyle(fontSize: screenWidth * 0.045, color: AppColors.primaryColor),
                              ),
                            );
                          }
                          return Center(child: Text('Error: ${state.error}'));
                        } else if (state is StationTripsSuccess) {
                          final trips = state.trips;
                          final soonTrips = trips.where((trip) => trip['tripState'] == 'soon').toList();
                          if (soonTrips.isEmpty) {
                            return const Center(child: Text('لا توجد رحلات حاليا'));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: soonTrips.length,
                            itemBuilder: (context, index) {
                              final trip = soonTrips[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                                child: ActiveTripsWidget(
                                  busId: trip['busId']?.toString() ?? '',
                                  tripId: trip['tripId']?.toString() ?? '',
                                  tripState: trip['tripState']?.toString() ?? 'unknown',
                                  firstTripRoute: trip['firstTripRoute'] ?? {},
                                  lastTripRoute: trip['lastTripRoute'] ?? {},
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  )
                else
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}