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
                            lbl: 'إلغاء الحجز',
                            onPressed: token == null
                                ? null
                                : () {
                                    _showCancelDialog(
                                      context,
                                      tripsCubit,
                                      tripId,
                                      token!,
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
                return Center(child: Text('Error: ${state.error}'));
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
              child: Text('هل انت متأكد من إلغاء حجز الرحلة'),
            ),
            content: SizedBox(
              width: 500,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("سوف تقوم بإلغاء حجز الحافلة رقم $tripId"),
                  const SizedBox(height: 20),
                  AppButton(
                    lbl: "تأكيد",
                    onPressed: () {
                      tripsCubit.cancelTicket(
                        tripId: int.parse(tripId),
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
                const Text('تم تأكيد إلغاء الحجز بنجاح'),
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

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حدث خطأ'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }
}