import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/core/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/dt_loading.dart';
import 'package:uot_transport/features/station_feature/presentation/cubit/stations_cubit.dart';
import 'package:uot_transport/features/station_feature/presentation/cubit/stations_state.dart';

import '../widgets/filter_widget.dart';
import '../widgets/search_bar.dart';
import '../widgets/station_list.dart';

class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  String selectedFilter = 'كل المحطات';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<StationsCubit>().fetchStations();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onFilterSelected(String value) {
    setState(() {
      selectedFilter = value;
    });

    // Clean-arch cubit currently only supports fetchStations().
    // We keep the UI control, and we'll wire filtering once the API/usecases support it.
    context.read<StationsCubit>().fetchStations();
  }

  void _onSearch(String query) {
    context.read<StationsCubit>().searchStations(query);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final padding = width * 0.05;
    final titleFontSize = width * 0.06;
    final filterFontSize = width * 0.045;
    final sectionSpacing = height * 0.025;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocBuilder<StationsCubit, StationsState>(
        builder: (context, state) {
          // Freezed-based state rendering
          if (state.maybeWhen(loading: () => true, initial: () => true, orElse: () => false)) {
            return const Center(child: DTLoading());
          }

          return state.when(
            initial: () => const Center(child: DTLoading()),
            loading: () => const Center(child: DTLoading()),
            failure: (failure) => Center(
              child: Text(
                failure.message,
                style: TextStyle(fontSize: width * 0.045, color: AppColors.primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
            loaded: (stations) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterWidget(
                        selectedFilter: selectedFilter,
                        onFilterSelected: _onFilterSelected,
                        fontSize: filterFontSize,
                      ),
                      AppText(
                        lbl: 'المحطات',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: SearchBar(onSearch: _onSearch),
                ),
                SizedBox(height: sectionSpacing),
                Expanded(
                  child: StationList(
                    stations: stations,
                    controller: _scrollController,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
