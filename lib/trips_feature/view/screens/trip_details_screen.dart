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

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final tripsCubit = context.read<TripsCubit>();
          tripsCubit.fetchTripRoutesFromApi(widget.tripId);
        });
      }

      Future<void> _initializeToken() async {
        final prefs = await SharedPreferences.getInstance();
        setState(() {
          token = prefs.getString('auth_token');
        });
      }

      @override
      Widget build(BuildContext context) {
        final tripsCubit = context.read<TripsCubit>();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: const BackHeader(),
            backgroundColor: AppColors.backgroundColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText(
                      lbl: ' الرحلة: #${widget.tripId}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    TripHeaderOptions(
                      tripId: widget.tripId,
                      busId: widget.busId,
                      tripState: widget.tripState,
                    ),
                    DepartureArrivalWidget(
                      lastTripRoute: widget.lastTripRoute,
                      firstTripRoute: widget.firstTripRoute,
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
                    BlocBuilder<TripsCubit, TripsState>(
                      builder: (context, state) {
                        if (state is TripRoutesLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is TripRoutesLoaded) {
                          final stations = state.tripRoutes
                              .map<String>((route) => route['stationName'] ?? 'Unknown')
                              .toList();
                          final currentStationIndex = state.tripRoutes.indexWhere(
                                (route) => route['state'] == 'Reached',
                          );
                          return BusTrackingWidget(
                            stations: state.tripRoutes,
                          );
                        } else if (state is TripRoutesError) {
                          return Center(child: Text('Error: ${state.error}'));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      lbl: 'حجز الرحلة',
                      onPressed: token == null
                          ? null
                          : () {
                              tripsCubit.fetchTripRoutesFromApi(widget.tripId);
                              _showStationDialog(
                                context,
                                tripsCubit,
                                widget.tripId,
                                token!,
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

      void _showStationDialog(BuildContext context, TripsCubit tripsCubit,
          String tripId, String token) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: const Align(
                  alignment: Alignment.centerRight,
                  child: Text('تفاصيل الرحلة'),
                ),
                content: SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.25,
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
                                SizedBox(height: screenHeight * 0.04),
                                ElevatedButton(
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
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('يرجى اختيار محطة البداية والنهاية'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('إرسال'),
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
      }

      void _showBookingDialog(BuildContext context, TripsCubit tripsCubit,
          String tripId, String fromStation, String toStation, int fromStationId,
          int toStationId, String token) {
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