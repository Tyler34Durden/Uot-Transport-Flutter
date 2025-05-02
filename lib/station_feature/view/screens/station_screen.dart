//added after emoved
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
  String selectedFilter = 'كل المحطات'; // القيمة الافتراضية

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocProvider(
        create: (context) => StationsCubit(context.read())..fetchStations(),
        child: BlocBuilder<StationsCubit, StationsState>(
          builder: (context, state) {
            if (state is StationsLoading) {
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
                          onFilterSelected: (String value) {
                            setState(() {
                              selectedFilter = value;
                              if (value == 'داخل الجامعة') {
                                context
                                    .read<StationsCubit>()
                                    .fetchStations(near: true);
                              } else if (value == 'خارج الجامعة') {
                                context
                                    .read<StationsCubit>()
                                    .fetchStations(near: false);
                              } else {
                                context.read<StationsCubit>().fetchStations();
                              }
                            });
                          },
                        ),
                        const AppText(
                          lbl: 'المحطات',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SearchBar(
                    onSearch: (query) {
                      // استدعاء دالة البحث عبر Cubit
                      context.read<StationsCubit>().searchStations(query);
                    },
                  ),
                  Expanded(
                    child: StationList(stations: state.stations),
                  ),
                ],
              );
            } else if (state is StationsFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }
}
