import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/dt_loading.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/features/home_feature/presentation/cubit/home_cubit.dart';
import 'package:uot_transport/features/home_feature/presentation/cubit/home_state.dart';
import 'package:uot_transport/features/home_feature/presentation/widgets/home_slider.dart';
import 'package:uot_transport/features/home_feature/presentation/widgets/station_filters.dart';
import 'package:uot_transport/features/home_feature/presentation/widgets/my_trips_widget.dart';
import 'package:uot_transport/features/home_feature/presentation/widgets/active_trips_widget.dart';
import 'package:uot_transport/features/home_feature/domain/entities/advertising_entity.dart';
import 'package:uot_transport/features/home_feature/domain/entities/home_trip_entity.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';

class CleanHomeScreen extends StatefulWidget {
  const CleanHomeScreen({super.key});

  @override
  State<CleanHomeScreen> createState() => _CleanHomeScreenState();
}

class _CleanHomeScreenState extends State<CleanHomeScreen> {
  int? selectedStationId;
  String? token;

  @override
  void initState() {
    super.initState();
    // Don't read HomeCubit here (BlocProvider isn't created yet).
    _loadTokenOnly();
  }

  Future<void> _loadTokenOnly() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedToken = prefs.getString('auth_token');
    if (!mounted) return;
    setState(() {
      token = loadedToken;
    });
  }

  Future<void> _loadHomeData(HomeCubit cubit) async {
    final t = token;
    if (t == null || t.isEmpty) return;
    await cubit.loadInitial(token: t);
    await cubit.loadTodayTrips(token: t);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final padding = width * 0.04;
    final titleFontSize = width * 0.05;
    final sectionSpacing = height * 0.03;
    final itemSpacing = height * 0.015;

    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>(),
      child: Builder(
        builder: (context) {
          // Run initial load once, after provider exists.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final cubit = context.read<HomeCubit>();
            _loadHomeData(cubit);
          });

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final isLoading = state.maybeWhen(
                    loading: (_, __, ___, ____) => true,
                    orElse: () => false,
                  );

                  final errorMessage = state.maybeWhen(
                    failure: (message, _, __, ___, ____) => message,
                    orElse: () => null,
                  );

                  final advertisings = state.maybeWhen(
                    loading: (ads, _, __, ___) => ads,
                    loaded: (ads, _, __, ___) => ads,
                    failure: (_, ads, __, ___, ____) => ads,
                    orElse: () => const <AdvertisingEntity>[],
                  );

                  final stations = state.maybeWhen(
                    loading: (_, stations, __, ___) => stations,
                    loaded: (_, stations, __, ___) => stations,
                    failure: (_, __, stations, ___, ____) => stations,
                    orElse: () => const <StationEntity>[],
                  );

                  final myTrips = state.maybeWhen(
                    loading: (_, __, myTrips, ___) => myTrips,
                    loaded: (_, __, myTrips, ___) => myTrips,
                    failure: (_, __, ___, myTrips, ____) => myTrips,
                    orElse: () => const <HomeTripEntity>[],
                  );

                  final todayTrips = state.maybeWhen(
                    loading: (_, __, ___, todayTrips) => todayTrips,
                    loaded: (_, __, ___, todayTrips) => todayTrips,
                    failure: (_, __, ___, ____, todayTrips) => todayTrips,
                    orElse: () => const <HomeTripEntity>[],
                  );

                  return RefreshIndicator(
                    onRefresh: () async {
                      final t = token;
                      if (t == null || t.isEmpty) return;
                      await context.read<HomeCubit>().loadInitial(token: t);
                      await context.read<HomeCubit>().loadTodayTrips(
                            token: t,
                            stationId: selectedStationId,
                          );
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isLoading && advertisings.isEmpty)
                              const Center(child: DTLoading())
                            else if (advertisings.isNotEmpty)
                              Column(
                                children: [
                                  HomeSlider(advertisings: advertisings),
                                  SizedBox(height: sectionSpacing),
                                ],
                              ),

                            Text(
                              'رحلاتي:',
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: sectionSpacing),

                            if (isLoading && myTrips.isEmpty)
                              const Center(child: DTLoading())
                            else if (myTrips.isNotEmpty)
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: myTrips.length,
                                itemBuilder: (context, index) {
                                  final trip = myTrips[index];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: itemSpacing),
                                    child: MyTripsWidget(trip: trip),
                                  );
                                },
                              )
                            else
                              Center(
                                child: Text(
                                  'لم تقم بحجز رحلات بعد',
                                  style: TextStyle(fontSize: width * 0.04),
                                ),
                              ),

                            SizedBox(height: sectionSpacing),

                            Text(
                              'رحلات اليوم:',
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            SizedBox(height: sectionSpacing),

                            // Only show filters when we actually have trips to filter.
                            if (stations.isNotEmpty && todayTrips.isNotEmpty) ...[
                              StationFilters(
                                selectedStationId: selectedStationId,
                                stations: stations,
                                onStationSelected: (stationId) async {
                                  setState(() {
                                    selectedStationId = stationId;
                                  });
                                  final t = token;
                                  if (t == null || t.isEmpty) return;
                                  await context
                                      .read<HomeCubit>()
                                      .loadTodayTrips(stationId: stationId, token: t);
                                },
                              ),
                              SizedBox(height: itemSpacing),
                            ],

                            if (isLoading && todayTrips.isEmpty)
                              const Center(child: DTLoading())
                            else if (errorMessage != null && todayTrips.isEmpty)
                              Center(
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(fontSize: width * 0.04),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else if (todayTrips.isNotEmpty)
                              Column(
                                children: [
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: todayTrips.length,
                                    itemBuilder: (context, index) {
                                      final trip = todayTrips[index];
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: itemSpacing),
                                        child: ActiveTripsWidget(
                                          busId: trip.busId,
                                          tripId: trip.tripId,
                                          tripState: trip.tripState,
                                          firstTripRoute: trip.firstTripRoute,
                                          lastTripRoute: trip.lastTripRoute,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            else
                              Center(
                                child: Text(
                                  'جاري تحميل الرحلات',
                                  style: TextStyle(fontSize: width * 0.04),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
