import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport/station_feature/view/widgets/google_map_widget.dart';
import 'package:uot_transport/station_feature/model/repository/station_trips_repository.dart';
import 'package:uot_transport/station_feature/view_model/cubit/station_trips_cubit.dart';
import 'package:uot_transport/station_feature/view_model/cubit/station_trips_state.dart';

class StationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> station;
  const StationDetailsScreen({super.key, required this.station});

@override
Widget build(BuildContext context) {
  final int stationId = station['id'];
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
          padding: EdgeInsets.all(screenWidth * 0.04), // Dynamic padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.3, // Dynamic height for the map
                child: GoogleMapWidget(
                  location: station['location'] ?? '0.0,0.0',
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Dynamic spacing
              AppText(
                lbl: station['name']?.toString() ?? 'No Title',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Dynamic font size
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
              const AppText(
                lbl: 'الرحلات القادمة:',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              BlocProvider(
                create: (context) => StationTripsCubit(StationTripsRepository())
                  ..fetchStationTrips(stationId),
                child: BlocBuilder<StationTripsCubit, StationTripsState>(
                  builder: (context, state) {
                    if (state is StationTripsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StationTripsFailure) {
                      return Center(child: Text('Error: ${state.error}'));
                    } else if (state is StationTripsSuccess) {
                      final trips = state.trips;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                            child: ActiveTripsWidget(
                              busId: trip['busId']?.toString() ?? '',
                              tripId: trip['tripId']?.toString() ?? '',
                              tripState:
                                  trip['tripState']?.toString() ?? 'unknown',
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
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}