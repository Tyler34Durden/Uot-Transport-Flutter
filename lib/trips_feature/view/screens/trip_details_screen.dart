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
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final tripsCubit = context.read<TripsCubit>();
    //   if (token != null) {
    //     tripsCubit.fetchTripDetailsScreen(widget.tripId, token!);
    //   }    });
  }


  Future<void> _initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedToken = prefs.getString('auth_token');
    setState(() {
      token = loadedToken;
    });
    if (loadedToken != null) {
      // Now that the token is available, fetch trip details
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<TripsCubit>().fetchTripDetailsScreen(widget.tripId, loadedToken);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tripsCubit = context.read<TripsCubit>();

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
              final bus = tripData['bus'] ?? {};
              final tripState = tripData['tripState'] ?? '';
              final tripRoutes = tripData['tripRoutes'] as List<dynamic>? ?? [];
              final firstTripRoute = tripRoutes.isNotEmpty ? tripRoutes.first : {};
              final lastTripRoute = tripRoutes.isNotEmpty ? tripRoutes.last : {};

              return RefreshIndicator(
                onRefresh: () async {
                  if (token != null) {
                    await context.read<TripsCubit>().fetchTripDetailsScreen(widget.tripId, token!);
                  }                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppText(
                          lbl: ' الرحلة: #$tripId',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        TripHeaderOptions(tripData: tripData),
                        DepartureArrivalWidget(
                          lastTripRoute: lastTripRoute,
                          firstTripRoute: firstTripRoute,
                        ),
                        const SizedBox(height: 20),
                        const AppText(
                          lbl: 'مسار الحافلة:',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        BusTrackingWidget(stations: tripRoutes.cast<Map<String, dynamic>>()),
                        const SizedBox(height: 20),
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
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is TripDetailsError) {
              return Center(child: Text('Error: ${state.error}'));
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
 ) {
   showDialog(
     context: context,
     barrierDismissible: false,
     builder: (BuildContext context) {
       final screenWidth = MediaQuery.of(context).size.width;
       final screenHeight = MediaQuery.of(context).size.height;

       if (tripRoutes.isEmpty) {
         return const AlertDialog(
           content: Center(child: Text('No routes available.')),
         );
       }

       final stationItems = tripRoutes
           .map<Map<String, dynamic>>((route) => {
                 'id': route['id'].toString(),
                 'name': route['stationName'] ?? 'Unknown',
                 'order': route['OrderNumber'] as int,
               })
           .toList();

       // Build id -> label map
       final fromItems = stationItems.sublist(0, stationItems.length - 1);
       final fromIdToLabel = {
         for (var item in fromItems) item['id'] as String: '${item['id']} - ${item['name']}'
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
             height: screenHeight * 0.275,
             child: StatefulBuilder(
               builder: (context, setState) {
                 // Only stations after the selected start
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
                     for (var item in toItems) item['id'] as String: '${item['id']} - ${item['name']}'
                   };
                   toLabels = toIdToLabel.values.toList();
                 }

                 return Column(
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
                           style: const TextStyle(color: Colors.red, fontSize: 14),
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
            content: Container(
              width: 500,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("سوف تقوم بحجز الحافلة رقم $tripId من $fromStation إلى $toStation"),
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
            width: 800,
            height: 150,
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