import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_dropdown.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/main_screen.dart';
import 'package:uot_transport/trips_feature/view/screens/trip_details_screen.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';

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
                      _showStationDialog(context, tripsCubit, widget.tripId, token!);
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
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            content: SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.275,
              child: BlocBuilder<TripsCubit, TripsState>(
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
                    final stationNames = tripRoutes
                        .map<String>((route) => route['stationName'] ?? 'Unknown')
                        .toList();
                    final stationIds = tripRoutes
                        .map<String>((route) => route['id'].toString())
                        .toList();
                    final orderNumbers = tripRoutes
                        .map<int>((route) => route['OrderNumber'] as int)
                        .toList();

                    String? selectedFromStation;
                    String? selectedToStation;
                    String? errorText;

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppDropdown(
                              items: stationNames.sublist(0, stationNames.length - 1),
                              hintText: 'اختر محطة البداية',
                              value: selectedFromStation,
                              onChanged: (value) {
                                setState(() {
                                  selectedFromStation = value;
                                  selectedToStation = null;
                                });
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            AppDropdown(
                              items: selectedFromStation != null
                                  ? stationNames.where((station) {
                                      final fromIndex = stationNames.indexOf(selectedFromStation!);
                                      final toIndex = stationNames.indexOf(station);
                                      return orderNumbers[toIndex] > orderNumbers[fromIndex];
                                    }).toList()
                                  : [],
                              hintText: 'اختر محطة النهاية',
                              value: selectedToStation,
                              onChanged: (value) {
                                setState(() {
                                  selectedToStation = value;
                                });
                              },
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            if ((errorText ?? '').isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: Text(
                                  errorText ?? '',
                                  style: const TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ),
                            SizedBox(height: screenHeight * 0.02),
                            AppButton(
                              lbl: "إرسال",
                              onPressed: () {
                                if (selectedFromStation != null && selectedToStation != null) {
                                  final fromStationId = stationIds[stationNames.indexOf(selectedFromStation!)];
                                  final toStationId = stationIds[stationNames.indexOf(selectedToStation!)];

                                  _showBookingDialog(
                                    context,
                                    tripsCubit,
                                    tripId,
                                    selectedFromStation!,
                                    selectedToStation!,
                                    int.parse(fromStationId),
                                    int.parse(toStationId),
                                    token,
                                  );
                                } else {
                                  setState(() {
                                    errorText = 'يرجى اختيار محطة البداية والنهاية';
                                  });
                                }
                              },
                              color: AppColors.primaryColor,
                              textColor: AppColors.backgroundColor,
                              width: 265,
                              height: 45,
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return const Center(child: Text('No data available.'));
                },
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    lbl: "إغلاق",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: AppColors.secondaryColor,
                    textColor: AppColors.primaryColor,
                    width: 265,
                    height: 45,
                  ),
                ],
              ),
            ],
          ),
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
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "سوف تقوم بحجز الحافلة رقم $tripId من $fromStation إلى $toStation",
                      style: const TextStyle(fontSize: 16),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
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
                        _showConfirmationDialog(context);
                      },
                      color: AppColors.primaryColor,
                      textColor: AppColors.backgroundColor,
                      width: 265,
                      height: 45,
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      lbl: "إلغاء",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: AppColors.secondaryColor,
                      textColor: AppColors.primaryColor,
                      width: 265,
                      height: 45,
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

  void _showConfirmationDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SvgPicture.asset("assets/icons/check.svg"),
          content: Container(
            width: screenWidth * 0.7,
            height: screenHeight * 0.22,
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
}