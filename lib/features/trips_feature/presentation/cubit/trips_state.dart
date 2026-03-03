import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/trip_route_entity.dart';

part 'trips_state.freezed.dart';

@freezed
class TripsState with _$TripsState {
  const factory TripsState.initial() = _Initial;

  // Trips list
  const factory TripsState.tripsLoading({@Default(false) bool isLoadMore}) = _TripsLoading;
  const factory TripsState.tripsLoaded({
    required List<TripEntity> trips,
    required bool hasMore,
    required int page,
  }) = _TripsLoaded;
  const factory TripsState.tripsFailure({required String message}) = _TripsFailure;

  // Trip routes for booking
  const factory TripsState.routesLoading() = _RoutesLoading;
  const factory TripsState.routesLoaded({required List<TripRouteEntity> routes}) = _RoutesLoaded;
  const factory TripsState.routesFailure({required String message}) = _RoutesFailure;

  // Ticket create/cancel/update
  const factory TripsState.ticketActionLoading() = _TicketActionLoading;
  const factory TripsState.ticketActionSuccess({required String message}) = _TicketActionSuccess;
  const factory TripsState.ticketActionFailure({required String message}) = _TicketActionFailure;

  // Trip details
  const factory TripsState.detailsLoading() = _DetailsLoading;
  const factory TripsState.detailsLoaded({required Map<String, dynamic> details}) = _DetailsLoaded;
  const factory TripsState.detailsFailure({required String message}) = _DetailsFailure;
 }
