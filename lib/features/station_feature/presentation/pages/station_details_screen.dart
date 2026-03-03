import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/core/widgets/app_text.dart' as clean_widgets;
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/features/trips_feature/presentation/widgets/active_trips_widget.dart';
import 'package:uot_transport/features/station_feature/presentation/cubit/station_trips_cubit.dart';
import 'package:uot_transport/features/station_feature/presentation/cubit/station_trips_state.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:url_launcher/url_launcher.dart';

class StationDetailsScreen extends StatefulWidget {
  const StationDetailsScreen({super.key, required this.args});

  final StationDetailsArgs args;

  @override
  State<StationDetailsScreen> createState() => _StationDetailsScreenState();
}

class _StationDetailsScreenState extends State<StationDetailsScreen> {
  String? _token;
  bool _didFetch = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final loaded = prefs.getString('auth_token');
    if (!mounted) return;

    setState(() {
      _token = loaded;
    });
  }

  void _maybeFetchTrips(StationTripsCubit cubit) {
    if (_didFetch) return;
    final t = _token;
    if (t == null || t.isEmpty) return;
    _didFetch = true;
    cubit.fetchStationTrips(stationId: widget.args.id, token: t);
  }

  LatLng _parseLocation(String location) {
    if (location.contains(',')) {
      final parts = location.split(',');
      if (parts.length >= 2) {
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) return LatLng(lat, lng);
      }
    }
    return const LatLng(0.0, 0.0);
  }

  Future<void> _openInGoogleMaps(LatLng latLng) async {
    // Prefer universal maps URL (works on Android/iOS/Web). Using externalApplication ensures it opens Google Maps if installed.
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}');
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Fallback to in-app web view / platform default
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      // Last-resort: do nothing (avoid crashing). UI can still show the embedded map.
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;

    final stationLatLng = _parseLocation(widget.args.location);

    return BlocProvider<StationTripsCubit>(
      create: (_) => getIt<StationTripsCubit>(),
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _maybeFetchTrips(context.read<StationTripsCubit>());
          });

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              appBar: const BackHeader(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.3,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                              onTap: () {
                                // Avoid opening (0,0) when backend sends invalid location.
                                if (stationLatLng.latitude == 0.0 && stationLatLng.longitude == 0.0) return;
                                _openInGoogleMaps(stationLatLng);
                              },
                              child: AbsorbPointer(
                                // Prevent map gestures from stealing the tap; tap should open Google Maps.
                                child: GoogleMap(
                                  initialCameraPosition:
                                      CameraPosition(target: stationLatLng, zoom: 16.0),
                                  markers: {
                                    Marker(
                                      markerId: const MarkerId('station_location'),
                                      position: stationLatLng,
                                    ),
                                  },
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      clean_widgets.AppText(
                        lbl: widget.args.name,
                        style: TextStyle(
                          fontSize: width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      const clean_widgets.AppText(
                        lbl: 'الرحلات :',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),

                      if (_token == null)
                        const Center(child: CircularProgressIndicator())
                      else
                        BlocBuilder<StationTripsCubit, StationTripsState>(
                          builder: (context, state) {
                            if (state.maybeWhen(loading: () => true, initial: () => true, orElse: () => false)) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            return state.when(
                              initial: () => const Center(child: CircularProgressIndicator()),
                              loading: () => const Center(child: CircularProgressIndicator()),
                              failure: (failure) => Center(
                                child: Text(
                                  failure.message,
                                  style: TextStyle(fontSize: width * 0.045, color: AppColors.primaryColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              loaded: (trips) {
                                final activeTrips = trips.where((t) => t.tripState == 'active').toList();

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: activeTrips.length,
                                  itemBuilder: (context, index) {
                                    final trip = activeTrips[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: height * 0.02),
                                      child: ActiveTripsWidget(
                                        busId: trip.busId,
                                        tripId: trip.tripId,
                                        tripState: trip.tripState,
                                        firstTripRoute: trip.firstTripRoute,
                                        lastTripRoute: trip.lastTripRoute,
                                        token: _token!,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),

                      SizedBox(height: height * 0.01),
                      const clean_widgets.AppText(
                        lbl: 'الرحلات القادمة:',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01),

                      if (_token != null)
                        BlocBuilder<StationTripsCubit, StationTripsState>(
                          builder: (context, state) {
                            if (state.maybeWhen(loading: () => true, initial: () => true, orElse: () => false)) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            return state.when(
                              initial: () => const Center(child: CircularProgressIndicator()),
                              loading: () => const Center(child: CircularProgressIndicator()),
                              failure: (failure) => Center(
                                child: Text(
                                  failure.message,
                                  style: TextStyle(fontSize: width * 0.045, color: AppColors.primaryColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              loaded: (trips) {
                                final soonTrips = trips.where((t) => t.tripState == 'soon').toList();

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: soonTrips.length,
                                  itemBuilder: (context, index) {
                                    final trip = soonTrips[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: height * 0.02),
                                      child: ActiveTripsWidget(
                                        busId: trip.busId,
                                        tripId: trip.tripId,
                                        tripState: trip.tripState,
                                        firstTripRoute: trip.firstTripRoute,
                                        lastTripRoute: trip.lastTripRoute,
                                        token: _token!,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class StationDetailsArgs {
  const StationDetailsArgs({
    required this.id,
    required this.name,
    required this.location,
  });

  final int id;
  final String name;
  final String location;
}
