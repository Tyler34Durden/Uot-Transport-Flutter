import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_dropdown.dart';
import 'package:uot_transport/features/trips_feature/presentation/cubit/trips_cubit.dart';
import 'package:uot_transport/features/trips_feature/presentation/cubit/trips_state.dart';

class TripSelectionWidget extends StatefulWidget {
  const TripSelectionWidget({super.key, this.token});

  final String? token;

  @override
  State<TripSelectionWidget> createState() => _TripSelectionWidgetState();
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
    // Prefer token passed from parent. Fallback to prefs.
    final passed = widget.token;
    if (passed != null && passed.trim().isNotEmpty) {
      setState(() {
        token = passed;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getIt<TripsCubit>().fetchTripsByStations(
          startStationId: null,
          endStationId: null,
          token: passed,
        );
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final loadedToken = prefs.getString('auth_token');
    setState(() {
      token = loadedToken;
    });
    if (loadedToken != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getIt<TripsCubit>().fetchTripsByStations(
          startStationId: null,
          endStationId: null,
          token: loadedToken,
        );
      });
    }
  }

  void _fetchTripsIfReady() {
    final t = token;
    if (t == null || t.isEmpty) return;

    getIt<TripsCubit>().fetchTripsByStations(
      startStationId: selectedStartId,
      endStationId: selectedEndId,
      token: t,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TripsCubit, TripsState>(
          bloc: getIt<TripsCubit>(),
          builder: (context, state) {
            final isLoading = state.maybeWhen(
              tripsLoading: (isLoadMore) => true,
              orElse: () => false,
            );
            if (isLoading) {
              return const Center();
            }

            return state.maybeWhen(
              tripsLoaded: (trips, hasMore, page) {
                // Legacy logic expected a list of maps with an embedded station object.
                // Clean tripsLoaded contains TripEntity, which doesn't include station.
                // So we show a safe fallback UI that still allows 'any station'.
                final stationNames = const ['اي محطة'];

                return Column(
                  children: [
                    AppDropdown(
                      items: stationNames,
                      hintText: 'من',
                      value: selectedStartName,
                      onChanged: (newValue) {
                        setState(() {
                          selectedStartName = newValue;
                          selectedStartId = null;
                        });
                        _fetchTripsIfReady();
                      },
                    ),
                    const SizedBox(height: 20),
                    AppDropdown(
                      items: stationNames,
                      hintText: 'الى',
                      value: selectedEndName,
                      onChanged: (newValue) {
                        setState(() {
                          selectedEndName = newValue;
                          selectedEndId = null;
                        });
                        _fetchTripsIfReady();
                      },
                    ),
                  ],
                );
              },
              tripsFailure: (message) {
                final isNoRouteToHost = message.toString().contains('No route to host');
                if (isNoRouteToHost) {
                  return const Center(
                    child: Text(
                      'لا يوجد اتصال بالخادم',
                      style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    'تعذّر تحميل فلاتر المحطات. يُرجى المحاولة مجددًا.',
                    style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
