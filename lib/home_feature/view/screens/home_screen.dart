import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport/home_feature/view/widgets/home_slider.dart';
import 'package:uot_transport/home_feature/view/widgets/my_trips_widget.dart';
import 'package:uot_transport/home_feature/view/widgets/city_filter_item.dart';
import 'package:uot_transport/home_feature/model/repository/home_repository.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_cubit.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_state.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_cubit.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AdvertisingsCubit, AdvertisingsState>(
                builder: (context, state) {
                  if (state is AdvertisingsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AdvertisingsLoaded) {
                    final advertisings = state.advertisings.cast<Map<String, dynamic>>();
                    return HomeSlider(advertisings: advertisings);
                  } else if (state is AdvertisingsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "رحلاتي:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 25),
              const MyTripsWidget(),
              const SizedBox(height: 10),
              const MyTripsWidget(),
              const SizedBox(height: 20),
              const Text(
                "رحلات اليوم:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 40,
                child: BlocBuilder<StationsCubit, StationsState>(
                  builder: (context, state) {
                    if (state is StationsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is StationsSuccess) {
                      final stations = state.stations;
                      return ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: stations.map<Widget>((station) {
                          final stationName = station['name'] ?? 'Unknown Station';
                          return CityFilterItem(
                            title: stationName,
                            isSelected: false, // Adjust selection logic
                          );
                        }).toList(),
                      );
                    } else if (state is StationsFailure) {
                      return Center(child: Text('Error: ${state.error}'));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<TripsCubit, TripsState>(
                  builder: (context, state) {
                    if (state is TripsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TripsLoaded) {
                      return ListView.builder(

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
                      );
                    } else if (state is TripsError) {
                      return Center(child: Text('Error: ${state.error}'));
                    }
                    return const Center(child: Text('No trips available'));
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