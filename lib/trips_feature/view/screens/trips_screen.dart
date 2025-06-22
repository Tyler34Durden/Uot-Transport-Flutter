import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/home_feature/view/widgets/active_trips_widget.dart';
import 'package:uot_transport/trips_feature/view/widgets/trip_selection_widget.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        token != null) {
      final cubit = context.read<TripsCubit>();
      setState(() => _isLoadingMore = true);
      cubit.fetchTripsByStations(loadMore: true, token: token!).whenComplete(() {
        if (mounted) setState(() => _isLoadingMore = false);
      });
    }
  }

  Future<void> _onRefresh() async {
    if (token != null) {
      await context.read<TripsCubit>().fetchTripsByStations(loadMore: false, token: token!);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

    return Directionality(
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
                padding: EdgeInsets.only(top: sectionSpacing, right: padding * 1.5),
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
              const TripSelectionWidget(),
              SizedBox(height: sectionSpacing),
              BlocBuilder<TripsCubit, TripsState>(
                builder: (context, state) {
                  if (state is TripsLoading && !_isLoadingMore) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TripsLoaded) {
                    final trips = state.trips;
                    if (trips.isEmpty) {
                      return Center(
                        child: Text('No trips available', style: TextStyle(fontSize: width * 0.04)),
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
                              tripId: trip['tripId']?.toString() ?? '',
                              tripState: trip['tripState'] ?? '',
                              firstTripRoute: trip['firstTripRoute'] ?? {},
                              lastTripRoute: trip['lastTripRoute'] ?? {},
                              busId: trip['busId']?.toString() ?? '',
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: itemSpacing),
                        ),
                        if (_isLoadingMore)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: itemSpacing * 2),
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    );
                  } else if (state is TripsError) {
                    return Center(
                      child: Text("لا توجد رحلات تبدأ بهذه المحطة", style: TextStyle(fontSize: width * 0.04)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}