import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:uot_transport/core/app_colors.dart';
import 'package:uot_transport/core/core_widgets/dt_loading.dart';
import 'package:uot_transport/core/locator.dart';
import 'package:uot_transport/core/widgets/app_button.dart';
import 'package:uot_transport/core/widgets/app_dropdown.dart';
import 'package:uot_transport/features/trips_feature/domain/entities/ticket_request.dart';
import 'package:uot_transport/features/trips_feature/presentation/cubit/trips_cubit.dart';
import 'package:uot_transport/features/trips_feature/presentation/cubit/trips_state.dart';

import '../pages/trip_details_screen.dart';

class ActiveTripsWidget extends StatefulWidget {
  const ActiveTripsWidget({
    super.key,
    required this.busId,
    required this.tripId,
    required this.tripState,
    required this.firstTripRoute,
    required this.lastTripRoute,
    required this.token,
  });

  final String busId;
  final String tripId;
  final String tripState;
  final Map<String, dynamic> firstTripRoute;
  final Map<String, dynamic> lastTripRoute;
  final String token;

  @override
  State<ActiveTripsWidget> createState() => _ActiveTripsWidgetState();
}

class _ActiveTripsWidgetState extends State<ActiveTripsWidget> {
  void _openBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider<TripsCubit>(
          create: (_) => getIt<TripsCubit>()..fetchTripRoutes(tripId: widget.tripId, token: widget.token),
          child: BlocConsumer<TripsCubit, TripsState>(
            listener: (context, state) {
              state.whenOrNull(
                ticketActionSuccess: (message) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
                ticketActionFailure: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
                routesFailure: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
              );
            },
            builder: (context, state) {
              final isBusy = state.maybeWhen(
                routesLoading: () => true,
                ticketActionLoading: () => true,
                orElse: () => false,
              );
              if (isBusy) {
                return const Center(child: DTLoading());
              }

              final routes = state.maybeWhen(
                routesLoaded: (routes) => routes,
                orElse: () => null,
              );

              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: const Align(
                    alignment: Alignment.centerRight,
                    child: Text('تفاصيل الرحلة'),
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: routes == null
                        ? const Text('جاري تحميل المحطات...')
                        : _BookingContent(
                            routes: routes,
                            onConfirm: (fromId, toId) {
                              context.read<TripsCubit>().createTicket(
                                    token: widget.token,
                                    request: TicketRequest(
                                      tripID: int.tryParse(widget.tripId) ?? 0,
                                      fromTripRoute: fromId,
                                      toTripRoute: toId,
                                    ),
                                  );
                            },
                          ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('إغلاق'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripDetailsScreen(
              tripId: widget.tripId,
              token: widget.token,
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
                  Text(' الحافلة ${_truncateText(widget.busId, 15)}'),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text('${widget.firstTripRoute['expectedTime']}'),
                      const Text(' - '),
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
                  lbl: 'حجز',
                  onPressed: () {
                    _openBookingDialog(context);
                  },
                  color: AppColors.secondaryColor,
                  textColor: AppColors.primaryColor,
                  width: screenWidth * 0.22,
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

class _BookingContent extends StatefulWidget {
  const _BookingContent({required this.routes, required this.onConfirm});

  final List routes;
  final void Function(int fromId, int toId) onConfirm;

  @override
  State<_BookingContent> createState() => _BookingContentState();
}

class _BookingContentState extends State<_BookingContent> {
  String? selectedFromLabel;
  String? selectedToLabel;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final stationItems = widget.routes
        .map<Map<String, dynamic>>((r) => {
              'id': r.id.toString(),
              'name': r.stationName,
              'order': r.orderNumber,
            })
        .toList();

    final fromItems = stationItems.sublist(0, stationItems.length - 1);
    final fromIdToLabel = {
      for (final item in fromItems)
        item['id'] as String: '${item['order']} - ${item['name']}'
    };

    final fromLabels = fromIdToLabel.values.toList();

    final selectedFromId = selectedFromLabel == null
        ? null
        : fromIdToLabel.entries
            .firstWhere((e) => e.value == selectedFromLabel)
            .key;

    final toItems = <Map<String, dynamic>>[];
    if (selectedFromId != null) {
      final fromIndex = stationItems.indexWhere((e) => e['id'] == selectedFromId);
      if (fromIndex != -1) {
        toItems.addAll(stationItems.sublist(fromIndex + 1));
      }
    }

    final toIdToLabel = {
      for (final item in toItems)
        item['id'] as String: '${item['order']} - ${item['name']}'
    };
    final toLabels = toIdToLabel.values.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppDropdown(
          items: fromLabels,
          hintText: 'من محطة',
          onChanged: (label) {
            setState(() {
              selectedFromLabel = label;
              selectedToLabel = null;
              errorText = null;
            });
          },
        ),
        const SizedBox(height: 12),
        AppDropdown(
          items: toLabels,
          hintText: 'إلى محطة',
          onChanged: (label) {
            setState(() {
              selectedToLabel = label;
              errorText = null;
            });
          },
        ),
        if (errorText != null) ...[
          const SizedBox(height: 12),
          Text(errorText!, style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 16),
        AppButton(
          lbl: 'تأكيد الحجز',
          onPressed: () {
            if (selectedFromLabel == null || selectedToLabel == null) {
              setState(() => errorText = 'يرجى اختيار محطة البداية والنهاية');
              return;
            }

            final fromId = int.parse(fromIdToLabel.entries
                .firstWhere((e) => e.value == selectedFromLabel)
                .key);
            final toId = int.parse(toIdToLabel.entries
                .firstWhere((e) => e.value == selectedToLabel)
                .key);

            widget.onConfirm(fromId, toId);
          },
          color: AppColors.primaryColor,
          textColor: AppColors.backgroundColor,
          width: double.infinity,
          height: 44,
        )
      ],
    );
  }
}
