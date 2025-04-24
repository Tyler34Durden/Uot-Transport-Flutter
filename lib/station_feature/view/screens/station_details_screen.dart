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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const BackHeader(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // تمرير قيمة الموقع إلى الـ GoogleMapWidget
              GoogleMapWidget(
                location: station['location']?.toString() ?? '',
              ),
              const SizedBox(height: 20),
              AppText(
                lbl: station['name']?.toString() ?? 'No Title',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              const AppText(
                lbl: 'الرحلات :',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // يمكن وضع ActiveTripsWidget هنا لعرض رحلات مختصرة إن وُجدت.
              const SizedBox(height: 10),
              const AppText(
                lbl: 'الرحلات القادمة:',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
                            padding: const EdgeInsets.only(bottom: 16.0),
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
    );
  }
}