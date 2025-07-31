import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/main_screen.dart';
import 'package:uot_transport/trips_feature/view/widgets/bus_tracking_widget.dart';
import 'package:uot_transport/trips_feature/view/widgets/departure_arrival_widget.dart';
import 'package:uot_transport/trips_feature/view/widgets/trip_header_options.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_dropdown.dart';

class TripDetailsScreen extends StatefulWidget {
  final String tripId;
  final String busId;
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const TripDetailsScreen({
    super.key,
    required this.tripId,
    required this.busId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedToken = prefs.getString('auth_token');
    setState(() {
      token = loadedToken;
    });
    if (loadedToken != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<TripsCubit>().fetchTripDetailsScreen(widget.tripId, loadedToken);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripsCubit = context.read<TripsCubit>();
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final padding = width * 0.04;
    final titleFontSize = width * 0.06;
    final sectionSpacing = height * 0.025;
    final labelFontSize = width * 0.05;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const BackHeader(),
        backgroundColor: AppColors.backgroundColor,
        body: BlocBuilder<TripsCubit, TripsState>(
          builder: (context, state) {
            if (state is TripDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TripDetailsLoaded) {
              final tripData = state.tripDetails;
              final tripId = tripData['tripId'].toString();
              final tripRoutes = tripData['tripRoutes'] as List<dynamic>? ?? [];
              final firstTripRoute = tripRoutes.isNotEmpty ? tripRoutes.first : {};
              final lastTripRoute = tripRoutes.isNotEmpty ? tripRoutes.last : {};

              return RefreshIndicator(
                onRefresh: () async {
                  if (token != null) {
                    await context.read<TripsCubit>().fetchTripDetailsScreen(widget.tripId, token!);
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppText(
                          lbl: ' الرحلة: #$tripId',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: sectionSpacing),
                        TripHeaderOptions(tripData: tripData),
                        SizedBox(height: sectionSpacing),
                        DepartureArrivalWidget(
                          lastTripRoute: lastTripRoute,
                          firstTripRoute: firstTripRoute,
                        ),
                        SizedBox(height: sectionSpacing),
                        AppText(
                          lbl: 'مسار الحافلة:',
                          style: TextStyle(
                            fontSize: labelFontSize,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: sectionSpacing * 0.5),
                        BusTrackingWidget(stations: tripRoutes.cast<Map<String, dynamic>>()),
                        SizedBox(height: sectionSpacing),
                        AppButton(
                          lbl: 'حجز الرحلة',
                          onPressed: token == null
                              ? null
                              : () {
                                  _showStationDialog(
                                    context,
                                    tripsCubit,
                                    tripId,
                                    token!,
                                    tripRoutes.cast<Map<String, dynamic>>(),
                                    width,
                                    height,
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is TripDetailsError) {
              return Center(child: Text('Error: ${state.error}', style: TextStyle(fontSize: width * 0.045)));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showStationDialog(
    BuildContext context,
    TripsCubit tripsCubit,
    String tripId,
    String token,
    List<Map<String, dynamic>> tripRoutes,
    double screenWidth,
    double screenHeight,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
              //height: screenHeight * 0.35,
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
                        items: fromLabels, // ['1 - StationA', '2 - StationB', ...]
                        hintText: 'اختر محطة البداية',
                        value: selectedFromLabel, // should be '1 - StationA', not just id
                        onChanged: (value) {
                          setState(() {
                            selectedFromLabel = value; // value is the label string
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
              // No height for flexibility
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
            // No height for flexibility
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