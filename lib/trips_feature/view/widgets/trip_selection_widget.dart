import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_dropdown.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_cubit.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_state.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';

class TripSelectionWidget extends StatefulWidget {
  const TripSelectionWidget({super.key});

  @override
  _TripSelectionWidgetState createState() => _TripSelectionWidgetState();
}

class _TripSelectionWidgetState extends State<TripSelectionWidget> {
  String? selectedStartName;
  String? selectedEndName;
  String? selectedStartId;
  String? selectedEndId;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedToken = prefs.getString('auth_token');
    setState(() {
      token = loadedToken;
    });
    if (loadedToken != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<StationsCubit>().fetchStations();
        context.read<TripsCubit>().fetchTripsByStations(
          startStationId: null,
          endStationId: null,
          token: loadedToken,
        );
      });
    }
  }

  void _fetchTripsIfReady() {
    if (token != null) {
      context.read<TripsCubit>().fetchTripsByStations(
        startStationId: selectedStartId,
        endStationId: selectedEndId,
        token: token!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<StationsCubit, StationsState>(
          builder: (context, state) {
            if (state is StationsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StationsSuccess) {
              final stations = state.stations ?? [];
              final stationList = stations.map((stationData) {
                final stationMap = stationData['station'];
                if (stationMap == null) {
                  throw Exception("Station data is null");
                }
                final id = stationMap['id']?.toString();
                final name = stationMap['name']?.toString();
                if (id == null || name == null) {
                  throw Exception("Station id or name is null");
                }
                return {'id': id, 'name': name};
              }).toList();

              final stationNames = [
                "اي محطة",
                ...stationList.map((item) => item['name']!).toSet().toList()
              ];

              // Filter 'to' station names to exclude the selected 'from' station (except for "اي محطة")
              final toStationNames = [
                "اي محطة",
                ...stationList
                  .map((item) => item['name']!)
                  .where((name) => name != selectedStartName)
                  .toSet()
                  .toList()
              ];

              // Filter 'from' station names to exclude the selected 'to' station (except for "اي محطة")
              final fromStationNames = [
                "اي محطة",
                ...stationList
                  .map((item) => item['name']!)
                  .where((name) => name != selectedEndName)
                  .toSet()
                  .toList()
              ];

              return Column(
                children: [
                  AppDropdown(
                    items: fromStationNames,
                    hintText: 'من',
                    value: selectedStartName,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStartName = newValue;
                        if (newValue == "اي محطة") {
                          selectedStartId = null;
                        } else {
                          selectedStartId = stationList
                              .firstWhere((item) => item['name'] == newValue)['id'];
                        }
                        // If the selected 'to' station is now the same as 'from', reset 'to'
                        if (selectedEndName == newValue) {
                          selectedEndName = null;
                          selectedEndId = null;
                        }
                      });
                      _fetchTripsIfReady();
                    },
                  ),
                  const SizedBox(height: 20),
                  AppDropdown(
                    items: toStationNames,
                    hintText: 'الى',
                    value: selectedEndName,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedEndName = newValue;
                        if (newValue == "اي محطة") {
                          selectedEndId = null;
                        } else {
                          selectedEndId = stationList
                              .firstWhere((item) => item['name'] == newValue)['id'];
                        }
                        // If the selected 'from' station is now the same as 'to', reset 'from'
                        if (selectedStartName == newValue) {
                          selectedStartName = null;
                          selectedStartId = null;
                        }
                      });
                      _fetchTripsIfReady();
                    },
                  ),
                ],
              );
            } else if (state is StationsFailure) {
              return const Center(
                child: Text(
                  'Failed to load station filters. Please try again.',
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}