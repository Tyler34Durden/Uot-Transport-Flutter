import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/station_feature/view/widgets/search_bar.dart';
import 'package:uot_transport/station_feature/view/widgets/station_list.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_cubit.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_state.dart';
import 'package:uot_transport/station_feature/view/widgets/filter_widget.dart';

class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  _StationScreenState createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  String selectedFilter = 'كل المحطات';
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<StationsCubit>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        cubit.hasMore) {
      setState(() => _isLoadingMore = true);
      cubit.fetchStations(loadMore: true).whenComplete(() {
        setState(() => _isLoadingMore = false);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterSelected(BuildContext context, String value) {
    setState(() {
      selectedFilter = value;
    });

    final cubit = context.read<StationsCubit>();
    if (value == 'داخل الجامعة') {
      cubit.fetchStations(near: true);
    } else if (value == 'خارج الجامعة') {
      cubit.fetchStations(near: false);
    } else {
      cubit.fetchStations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<StationsCubit, StationsState>(
        builder: (context, state) {
          if (state is StationsLoading && !(state is StationsSuccess)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StationsSuccess) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterWidget(
                        selectedFilter: selectedFilter,
                        onFilterSelected: (value) => _onFilterSelected(context, value),
                      ),
                      const AppText(
                        lbl: 'المحطات',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SearchBar(
                  onSearch: (query) {
                    context.read<StationsCubit>().searchStations(query);
                  },
                ),
                Expanded(
                  child: Stack(
                    children: [
                      StationList(
                        stations: state.stations,
                        controller: _scrollController,
                      ),
                      if (_isLoadingMore)
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 8,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is StationsFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
