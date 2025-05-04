import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_dropdown.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/main_screen.dart';
import 'package:uot_transport/trips_feature/view/screens/trip_details_screen.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';

class ActiveTripsWidget extends StatelessWidget {
  final String busId;
  final String tripId;
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const ActiveTripsWidget({
    super.key,
    required this.busId,
    required this.tripId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  @override
  Widget build(BuildContext context) {
    final tripsCubit = context.read<TripsCubit>(); // Access TripsCubit instance

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(
              tripId: tripId,
              busId: busId,
              tripState: tripState,
              firstTripRoute: firstTripRoute,
              lastTripRoute: lastTripRoute,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 5),
            SvgPicture.asset('assets/icons/bus.svg'),
            const SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' الحافلة ${_truncateText(busId.toString(), 15)}',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      Text('${firstTripRoute['expectedTime']}'),
                      Text(' - '),
                      Text('${lastTripRoute['expectedTime']}'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        _truncateText('${firstTripRoute['stationName']}', 8),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SvgPicture.asset(
                        'assets/icons/arrow-right-circle.svg',
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _truncateText('${lastTripRoute['stationName']}', 8),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 15),
                AppButton(
                  lbl: "حجز",
                  onPressed: () {
                    tripsCubit.fetchTripRoutes(tripId);
                    _showStationDialog(context, tripsCubit); // Pass TripsCubit
                  },
                  color: AppColors.secondaryColor,
                  textColor: AppColors.primaryColor,
                  width: 92,
                  height: 36,
                ),
              ],
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
  }
}
void _showStationDialog(BuildContext context, TripsCubit tripsCubit) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Align(
            alignment: Alignment.centerRight,
            child: Text('تفاصيل الرحلة'),
          ),
          content: BlocBuilder<TripsCubit, TripsState>(
            bloc: tripsCubit,
            builder: (context, state) {
              if (state is TripRoutesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TripRoutesError) {
                return Center(child: Text('Error: ${state.error}'));
              } else if (state is TripRoutesLoaded) {
                final tripRoutes = state.tripRoutes;

                if (tripRoutes.isEmpty) {
                  return const Center(child: Text('No routes available.'));
                }

                // Extract station names for the dropdown
                final stationNames = tripRoutes
                    .map<String>((route) => route['stationName'] ?? 'Unknown')
                    .toList();

                String? selectedStation;

                return StatefulBuilder(
                  builder: (context, setState) {
                    return AppDropdown(
                      items: stationNames,
                      hintText: 'اختر محطة',
                      value: selectedStation,
                      onChanged: (value) {
                        setState(() {
                          selectedStation = value;
                        });
                      },
                    );
                  },
                );
              }
              return const Center(child: Text('No data available.'));
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إغلاق'),
            ),
          ],
        ),
      );
    },
  );


}void _showBookingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Align(
              alignment: Alignment.centerRight,
              child: Text('هل انت متأكد من حجز الحافلة #')),
          content: Container(
            width: 500, // Set the desired width
            height: 150, // Set the desired height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("سوف تقوم بحجز الحافلة من كلية الى الفرناج"),
                const SizedBox(height: 20,),
                AppButton(
                  lbl: "تأكيد الحجز",
                  onPressed: () {
                    _showConfirmationDialog(context);
                  },
                  color: AppColors.primaryColor,
                  textColor: AppColors.backgroundColor,
                  width: 265,
                  height: 45,
                ),
                const SizedBox(height:10),
                AppButton(
                  lbl: "إلغاء",
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  color: AppColors.secondaryColor,
                  textColor: AppColors.primaryColor,
                  width: 265,
                  height: 45,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}


void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: SvgPicture.asset("assets/icons/check.svg"),
        content: Container(
          width: 800, // Set the desired width
          height: 150, // Set the desired height
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('تم تأكيد الحجز بنجاح'),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                child: const Text('الذهاب إلى الصفحة الرئيسية'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
