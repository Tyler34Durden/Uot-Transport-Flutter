import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/dt_loading.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_text.dart';
import 'package:uot_transport/features/trips_feature/presentation/cubit/trips_cubit.dart';
import 'package:uot_transport/features/trips_feature/presentation/cubit/trips_state.dart';
import 'package:uot_transport/features/trips_feature/presentation/widgets/trip_selection_widget.dart';

import '../widgets/active_trips_widget.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key, required this.token});

  final String token;

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String? _lastServerMessage;
  late final TripsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<TripsCubit>();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.fetchTripsByStations(loadMore: false, token: widget.token);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      _cubit.fetchTripsByStations(loadMore: true, token: widget.token).whenComplete(() {
        if (mounted) setState(() => _isLoadingMore = false);
      });
    }
  }

  Future<void> _onRefresh() async {
    await _cubit.fetchTripsByStations(loadMore: false, token: widget.token);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final padding = width * 0.04;
    final titleFontSize = width * 0.06;
    final sectionSpacing = height * 0.03;
    final itemSpacing = height * 0.015;

    return BlocProvider<TripsCubit>.value(
      value: _cubit,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              controller: _scrollController,
              padding: EdgeInsets.all(padding),
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: sectionSpacing, right: padding * 1.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        lbl: 'الرحلات',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                TripSelectionWidget(token: widget.token),
                SizedBox(height: sectionSpacing),
                BlocBuilder<TripsCubit, TripsState>(
                  builder: (context, state) {
                    // cache last backend message for the "empty" case.
                    state.maybeWhen(
                      tripsFailure: (message) => _lastServerMessage = message,
                      orElse: () {},
                    );

                    final isInitialLoading = state.maybeWhen(
                      tripsLoading: (isLoadMore) => !isLoadMore && !_isLoadingMore,
                      orElse: () => false,
                    );
                    if (isInitialLoading) {
                      return const Center(child: DTLoading());
                    }

                    return state.maybeWhen(
                      tripsLoaded: (trips, hasMore, page) {
                        if (trips.isEmpty) {
                          final msg = _lastServerMessage;
                          return Center(
                            child: Text(
                              (msg != null && msg.trim().isNotEmpty)
                                  ? msg
                                  : 'لا توجد رحلات',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: width * 0.04),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: trips.length,
                              itemBuilder: (context, index) {
                                final trip = trips[index];
                                return ActiveTripsWidget(
                                  key: ValueKey(trip.tripId),
                                  tripId: trip.tripId,
                                  tripState: trip.tripState,
                                  firstTripRoute: trip.firstTripRoute,
                                  lastTripRoute: trip.lastTripRoute,
                                  busId: trip.busId,
                                  token: widget.token,
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(height: itemSpacing),
                            ),
                            if (_isLoadingMore)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: itemSpacing * 2),
                                child: const Center(child: DTLoading()),
                              ),
                          ],
                        );
                      },
                      tripsFailure: (message) {
                        final isNoRouteToHost = message.contains('No route to host');
                        if (isNoRouteToHost) {
                          return Center(
                            child: Text(
                              'لا يوجد اتصال بالخادم',
                              style: TextStyle(
                                fontSize: width * 0.045,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          );
                        }

                        return Center(
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: width * 0.04),
                          ),
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
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

