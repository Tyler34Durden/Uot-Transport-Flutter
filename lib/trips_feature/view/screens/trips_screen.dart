// File: lib/trips_feature/view/screens/trips_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport/trips_feature/view/widgets/trip_selection_widget.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 28, right: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    lbl: 'الرحلات',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // The filter widget updates the TripsCubit state to fetch trips.
            const TripSelectionWidget(),
            const SizedBox(height: 20),
            // Show trips based on the filtered selection.
            BlocBuilder<TripsCubit, TripsState>(
              builder: (context, state) {
                if (state is TripsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TripsLoaded) {
                  final trips = state.trips;
                  if (trips.isEmpty) {
                    return const Center(child: Text('No trips available'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return ActiveTripsWidget(
                        tripId: trip['tripId']?.toString() ?? '',
                        tripState: trip['tripState'] ?? '',
                        firstTripRoute: trip['firstTripRoute'] ?? {},
                        lastTripRoute: trip['lastTripRoute'] ?? {},
                        busId: trip['busId']?.toString() ?? '',
                      );
                    },
                  );
                } else if (state is TripsError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}