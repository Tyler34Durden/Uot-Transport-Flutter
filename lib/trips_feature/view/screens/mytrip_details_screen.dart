import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_button.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_text.dart';
import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/main_screen.dart';
import 'package:uot_transport/trips_feature/view/screens/mytrip_scanner.dart';
import 'package:uot_transport/trips_feature/view/widgets/bus_tracking_widget.dart';
import 'package:uot_transport/trips_feature/view/widgets/departure_arrival_widget.dart';
import 'package:uot_transport/trips_feature/view/widgets/trip_header_options.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_state.dart';
import 'package:uot_transport/auth_feature/view/widgets/app_dropdown.dart';

class MyTripDetailsScreen extends StatefulWidget {
  final String tripId;
  final String busId;
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;

  const MyTripDetailsScreen({
    super.key,
    required this.tripId,
    required this.busId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
  });

  @override
  State<MyTripDetailsScreen> createState() => _MyTripDetailsScreenState();
}

class _MyTripDetailsScreenState extends State<MyTripDetailsScreen> {
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
      final tripsCubit = context.read<TripsCubit>();
      tripsCubit.fetchTripDetailsScreen(widget.tripId, loadedToken);
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
    final labelFontSize = width * 0.045;
    final iconSize = width * 0.25;

    return BlocListener<TripsCubit, TripsState>(
      listener: (context, state) {
        if (state is TripCancelError) {
          _showErrorDialog(context, state.errorMessage);
        }
      },
      child: Directionality(
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
                          SizedBox(height: sectionSpacing / 2),
                          Icon(Icons.qr_code_scanner, size: iconSize, color: AppColors.primaryColor),
                          SizedBox(height: sectionSpacing / 2),
                          AppButton(
                            lbl: 'مسح رمز QR',
                            icon: Icons.camera_alt,
                            onPressed: () async {
                              final tripRouteId = firstTripRoute['id'];
                              final tripId = tripData['tripId'];
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyTripScanner(
                                    tripId: tripId,
                                    tripRouteId: tripRouteId,
                                    token: token!,
                                    busId: bus['id']?.toString() ?? '',
                                    tripState: tripState,
                                    firstTripRoute: firstTripRoute,
                                    lastTripRoute: lastTripRoute,
                                  ),
                                ),
                              );
                              if (result != null) {
                                print('Scanned QR value: $result');
                              }
                            },
                            color: AppColors.primaryColor,
                            textColor: AppColors.backgroundColor,
                          ),
                          SizedBox(height: sectionSpacing / 2),
                          TripHeaderOptions(tripData: tripData),
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
                          SizedBox(height: sectionSpacing / 2),
                          BusTrackingWidget(stations: tripRoutes.cast<Map<String, dynamic>>()),
                          SizedBox(height: sectionSpacing),
                          AppButton(
                            lbl: 'إلغاء الحجز',
                            onPressed: token == null
                                ? null
                                : () {
                                    _showCancelDialog(
                                      context,
                                      tripsCubit,
                                      tripId,
                                      token!,
                                      width,
                                      height,
                                    );
                                  },
                            color: const Color(0xFFC12828),
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
      ),
    );
  }

  void _showCancelDialog(
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
        final dialogWidth = screenWidth * 0.8;
        final dialogHeight = screenHeight * 0.22;
        final buttonWidth = screenWidth * 0.6;
        final buttonHeight = screenHeight * 0.06;
        final fontSize = screenWidth * 0.045;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Align(
              alignment: Alignment.centerRight,
              child: Text('هل انت متأكد من إلغاء حجز الرحلة', style: TextStyle(fontSize: fontSize)),
            ),
            content: SizedBox(
              width: dialogWidth,
              height: dialogHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("سوف تقوم بإلغاء حجز الحافلة رقم $tripId", style: TextStyle(fontSize: fontSize)),
                  SizedBox(height: screenHeight * 0.02),
                  AppButton(
                    lbl: "تأكيد",
                    onPressed: () {
                      tripsCubit.cancelTicket(
                        tripId: int.parse(tripId),
                        token: token,
                      );
                      Navigator.of(context).pop();
                      _showConfirmationDialog(context, screenWidth, screenHeight);
                    },
                    color: AppColors.primaryColor,
                    textColor: AppColors.backgroundColor,
                    width: buttonWidth,
                    height: buttonHeight,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  AppButton(
                    lbl: "إلغاء",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: AppColors.secondaryColor,
                    textColor: AppColors.primaryColor,
                    width: buttonWidth,
                    height: buttonHeight,
                  ),
                ],
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
        final dialogWidth = screenWidth * 0.8;
        final dialogHeight = screenHeight * 0.18;
        final fontSize = screenWidth * 0.045;

        return AlertDialog(
          title: SvgPicture.asset("assets/icons/check.svg"),
          content: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('تم تأكيد إلغاء الحجز بنجاح', style: TextStyle(fontSize: fontSize)),
                SizedBox(height: screenHeight * 0.025),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                    );
                  },
                  child: Text('الذهاب إلى الصفحة الرئيسية', style: TextStyle(fontSize: fontSize)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    final width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حدث خطأ', style: TextStyle(fontSize: width * 0.045)),
        content: Text(errorMessage, style: TextStyle(fontSize: width * 0.04)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('حسناً', style: TextStyle(fontSize: width * 0.04)),
          ),
        ],
      ),
    );
  }
}