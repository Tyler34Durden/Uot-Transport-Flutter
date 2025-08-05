import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../auth_feature/view/widgets/app_button.dart';
import '../../../auth_feature/view/widgets/app_dropdown.dart';
import '../../../core/main_screen.dart';
import '../../../core/app_colors.dart';
import '../../../trips_feature/view/screens/trip_details_screen.dart';
import '../../../trips_feature/view_model/cubit/trips_cubit.dart';
import '../../../trips_feature/view_model/cubit/trips_state.dart';

class ActiveTripsWidget extends StatefulWidget {
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
  _ActiveTripsWidgetState createState() => _ActiveTripsWidgetState();
}

class _ActiveTripsWidgetState extends State<ActiveTripsWidget> {
  String? token;

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('auth_token');
    });
    if (token == null) {
      debugPrint('Token not found. Redirecting to login...');
      // Handle token absence (e.g., redirect to login)
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripsCubit = context.read<TripsCubit>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(
              tripId: widget.tripId,
              busId: widget.busId,
              tripState: widget.tripState,
              firstTripRoute: widget.firstTripRoute,
              lastTripRoute: widget.lastTripRoute,
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
                    ' الحافلة ${_truncateText(widget.busId.toString(), 15)}',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      Text('${widget.firstTripRoute['expectedTime']}'),
                      Text(' - '),
                      Text('${widget.lastTripRoute['expectedTime']}'),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        _truncateText('${widget.firstTripRoute['stationName']}', 8),
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
                        _truncateText('${widget.lastTripRoute['stationName']}', 8),
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
                    if (token != null) {
                      tripsCubit.fetchTripRoutes(widget.tripId, token!);
                      _showStationDialog(context, tripsCubit, widget.tripId, token!, screenWidth, screenHeight);
                    }
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

  void _showStationDialog(
      BuildContext context,
      TripsCubit tripsCubit,
      String tripId,
      String token,
      double screenWidth,
      double screenHeight,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocBuilder<TripsCubit, TripsState>(
          builder: (context, state) {
            if (state is TripsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TripRoutesLoaded) {
              final tripRoutes = state.tripRoutes;
              if (tripRoutes.isEmpty) {
                return const AlertDialog(
                  content: Center(child: Text('لا توجد محطات متاحة لهذه الرحلة')),
                );
              }

              final stationItems = tripRoutes
                  .map<Map<String, dynamic>>((route) => {
                'id': route['id'].toString(),
                'name': route['stationName'] ?? 'Unknown',
                'order': route['OrderNumber'] as int,
              })
                  .toList();

              final fromItems = stationItems.sublist(0, stationItems.length - 1);
              final fromIdToLabel = {
                for (var item in fromItems) item['id'] as String: '${item['order']} - ${item['name']}'
              };
              final fromLabels = fromIdToLabel.values.toList();

              String? selectedFromLabel;
              String? selectedToLabel;
              String? selectedFromStationId;
              String? selectedToStationId;
              String? errorText;

              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('تفاصيل الرحلة'),
                  ),
                  content: SizedBox(
                    width: screenWidth * 0.9,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        List<Map<String, dynamic>> toItems = [];
                        Map<String, String> toIdToLabel = {};
                        List<String> toLabels = [];
                        if (selectedFromLabel != null) {
                          selectedFromStationId = fromIdToLabel.entries
                              .firstWhere((entry) => entry.value == selectedFromLabel)
                              .key;
                          final fromOrder = fromItems
                              .firstWhere((e) => e['id'] == selectedFromStationId)['order'];
                          toItems = stationItems.where((item) => item['order'] > fromOrder).toList();
                          toIdToLabel = {
                            for (var item in toItems) item['id'] as String: '${item['order']} - ${item['name']}'
                          };
                          toLabels = toIdToLabel.values.toList();
                        }
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppDropdown(
                                items: fromLabels,
                                hintText: 'اختر محطة البداية',
                                value: selectedFromLabel,
                                onChanged: (value) {
                                  setState(() {
                                    selectedFromLabel = value;
                                    selectedToLabel = null;
                                    errorText = null;
                                  });
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              AppDropdown(
                                items: toLabels,
                                hintText: 'اختر محطة النهاية',
                                value: selectedToLabel,
                                onChanged: (value) {
                                  setState(() {
                                    selectedToLabel = value;
                                    errorText = null;
                                  });
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              if ((errorText ?? '').isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 1.0),
                                  child: Text(
                                    errorText ?? '',
                                    style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.035),
                                  ),
                                ),
                              SizedBox(height: screenHeight * 0.02),
                              AppButton(
                                lbl: "إرسال",
                                onPressed: () {
                                  if (selectedFromLabel != null && selectedToLabel != null) {
                                    selectedFromStationId = fromIdToLabel.entries
                                        .firstWhere((entry) => entry.value == selectedFromLabel)
                                        .key;
                                    selectedToStationId = toIdToLabel.entries
                                        .firstWhere((entry) => entry.value == selectedToLabel)
                                        .key;

                                    final fromStation = stationItems.firstWhere((e) => e['id'] == selectedFromStationId);
                                    final toStation = stationItems.firstWhere((e) => e['id'] == selectedToStationId);

                                    _showBookingDialog(
                                      context,
                                      tripsCubit,
                                      tripId,
                                      fromStation['name'],
                                      toStation['name'],
                                      int.parse(fromStation['id']),
                                      int.parse(toStation['id']),
                                      token,
                                      screenWidth,
                                      screenHeight,
                                    );
                                  } else {
                                    setState(() {
                                      errorText = 'يرجى اختيار محطة البداية والنهاية';
                                    });
                                  }
                                },
                                color: AppColors.primaryColor,
                                textColor: AppColors.backgroundColor,
                                width: screenWidth * 0.7,
                                height: screenHeight * 0.06,
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              AppButton(
                                lbl: "إغلاق",
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                color: AppColors.secondaryColor,
                                textColor: AppColors.primaryColor,
                                width: double.infinity,
                                height: screenHeight * 0.06,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
            // Default: show loading
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  void _showBookingDialog(
      BuildContext context,
      TripsCubit tripsCubit,
      String tripId,
      String fromStation,
      String toStation,
      int fromStationId,
      int toStationId,
      String token,
      double screenWidth,
      double screenHeight,
      ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Align(
              alignment: Alignment.centerRight,
              child: Text('هل انت متأكد من حجز الحافلة؟'),
            ),
            content: SizedBox(
              width: screenWidth * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "سوف تقوم بحجز الحافلة رقم $tripId من $fromStation إلى $toStation",
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    AppButton(
                      lbl: "تأكيد الحجز",
                      onPressed: () {
                        tripsCubit.createTicket(
                          tripID: int.parse(tripId),
                          fromTripRoute: fromStationId,
                          toTripRoute: toStationId,
                          token: token,
                        );
                        Navigator.of(context).pop();
                        _showConfirmationDialog(context, screenWidth, screenHeight);
                      },
                      color: AppColors.primaryColor,
                      textColor: AppColors.backgroundColor,
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.06,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    AppButton(
                      lbl: "إلغاء",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: AppColors.secondaryColor,
                      textColor: AppColors.primaryColor,
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.06,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, double screenWidth, double screenHeight) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SvgPicture.asset("assets/icons/check.svg"),
          content: SizedBox(
            width: screenWidth * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('تم تأكيد الحجز بنجاح', style: TextStyle(fontSize: screenWidth * 0.045)),
                  SizedBox(height: screenHeight * 0.025),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                      );
                    },
                    child: Text('الذهاب إلى الصفحة الرئيسية', style: TextStyle(fontSize: screenWidth * 0.045)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}