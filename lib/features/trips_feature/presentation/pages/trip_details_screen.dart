import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/back_header.dart';
import 'package:uot_transport/core/core_widgets/dt_loading.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_dropdown.dart';
import 'package:uot_transport/core/widgets/app_text.dart';
import 'package:uot_transport/features/trips_feature/domain/entities/ticket_request.dart';
import 'package:uot_transport/features/trips_feature/presentation/cubit/trips_cubit.dart';
import 'package:uot_transport/features/trips_feature/presentation/cubit/trips_state.dart';

import '../widgets/bus_tracking_widget.dart';
import '../widgets/departure_arrival_widget.dart';
import '../widgets/trip_header_options.dart';

/// Clean Trip Details screen.
///
/// For now it reuses the backend response map and legacy UI widgets can be
/// migrated later. This keeps architecture clean (data via usecase/cubit),
/// while avoiding a large UI rewrite.
class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({
    super.key,
    required this.tripId,
    required this.token,
  });

  final String tripId;
  final String token;

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final padding = width * 0.04;
    final titleFontSize = width * 0.06;
    final sectionSpacing = height * 0.025;
    final labelFontSize = width * 0.05;

    return BlocProvider<TripsCubit>(
      create: (_) => getIt<TripsCubit>()..fetchTripDetails(tripId: widget.tripId, token: widget.token),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: const BackHeader(),
          backgroundColor: AppColors.backgroundColor,
          body: BlocConsumer<TripsCubit, TripsState>(
            listener: (context, state) {
              state.whenOrNull(
                ticketActionSuccess: (message) {
                  _showConfirmationDialog(context, width, height);
                },
                ticketActionFailure: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                detailsLoading: () => const Center(child: DTLoading()),
                detailsFailure: (message) => Center(
                  child: Text(
                    'Error: $message',
                    style: TextStyle(fontSize: width * 0.045),
                  ),
                ),
                detailsLoaded: (details) {
                  final tripData = details;
                  final tripId = tripData['tripId'].toString();
                  final tripRoutes = tripData['tripRoutes'] as List<dynamic>? ?? [];
                  final firstTripRoute =
                      tripRoutes.isNotEmpty ? tripRoutes.first as Map : <String, dynamic>{};
                  final lastTripRoute =
                      tripRoutes.isNotEmpty ? tripRoutes.last as Map : <String, dynamic>{};

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<TripsCubit>().fetchTripDetails(
                            tripId: widget.tripId,
                            token: widget.token,
                          );
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
                            TripHeaderOptions(tripData: tripData.cast<String, dynamic>()),
                            SizedBox(height: sectionSpacing),
                            DepartureArrivalWidget(
                              lastTripRoute: lastTripRoute.cast<String, dynamic>(),
                              firstTripRoute: firstTripRoute.cast<String, dynamic>(),
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
                              onPressed: () {
                                _showStationDialog(
                                  context,
                                  context.read<TripsCubit>(),
                                  tripId,
                                  widget.token,
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
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
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
            .map<Map<String, dynamic>>(
              (route) => {
                'id': route['id'].toString(),
                'name': route['stationName'] ?? 'Unknown',
                'order': route['OrderNumber'] as int,
              },
            )
            .toList();

        final fromItems = stationItems.sublist(0, stationItems.length - 1);
        final fromIdToLabel = {
          for (final item in fromItems)
            item['id'] as String: '${item['order']} - ${item['name']}'
        };
        final fromLabels = fromIdToLabel.values.toList();

        String? selectedFromLabel;
        String? selectedToLabel;
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
                  final selectedFromId = selectedFromLabel == null
                      ? null
                      : fromIdToLabel.entries
                          .firstWhere((e) => e.value == selectedFromLabel)
                          .key;

                  final toItems = <Map<String, dynamic>>[];
                  if (selectedFromId != null) {
                    final fromOrder = fromItems
                        .firstWhere((e) => e['id'] == selectedFromId)['order'] as int;
                    toItems.addAll(
                      stationItems.where((item) => (item['order'] as int) > fromOrder),
                    );
                  }

                  final toIdToLabel = {
                    for (final item in toItems)
                      item['id'] as String: '${item['order']} - ${item['name']}'
                  };
                  final toLabels = toIdToLabel.values.toList();

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
                            padding: const EdgeInsets.only(bottom: 1),
                            child: Text(
                              errorText ?? '',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                        SizedBox(height: screenHeight * 0.02),
                        AppButton(
                          lbl: 'إرسال',
                          onPressed: () {
                            if (selectedFromLabel == null || selectedToLabel == null) {
                              setState(() {
                                errorText = 'يرجى اختيار محطة البداية والنهاية';
                              });
                              return;
                            }

                            final fromId = fromIdToLabel.entries
                                .firstWhere((e) => e.value == selectedFromLabel)
                                .key;
                            final toId = toIdToLabel.entries
                                .firstWhere((e) => e.value == selectedToLabel)
                                .key;

                            final fromStation = stationItems.firstWhere((e) => e['id'] == fromId);
                            final toStation = stationItems.firstWhere((e) => e['id'] == toId);

                            _showBookingDialog(
                              context,
                              tripsCubit,
                              tripId,
                              fromStation['name'] as String,
                              toStation['name'] as String,
                              int.parse(fromStation['id'] as String),
                              int.parse(toStation['id'] as String),
                              token,
                              screenWidth,
                              screenHeight,
                            );
                          },
                          color: AppColors.primaryColor,
                          textColor: AppColors.backgroundColor,
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.06,
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        AppButton(
                          lbl: 'إغلاق',
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'سوف تقوم بحجز الحافلة رقم $tripId من $fromStation إلى $toStation',
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    AppButton(
                      lbl: 'تأكيد الحجز',
                      onPressed: () {
                        tripsCubit.createTicket(
                          token: token,
                          request: TicketRequest(
                            tripID: int.parse(tripId),
                            fromTripRoute: fromStationId,
                            toTripRoute: toStationId,
                          ),
                        );
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      color: AppColors.primaryColor,
                      textColor: AppColors.backgroundColor,
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.06,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    AppButton(
                      lbl: 'إلغاء',
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
          title: SvgPicture.asset('assets/icons/check.svg'),
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
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                    child: Text(
                      'الذهاب إلى الصفحة الرئيسية',
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
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
