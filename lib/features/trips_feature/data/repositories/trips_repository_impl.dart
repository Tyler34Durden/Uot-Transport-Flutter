import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/core/utilities.dart';

import '../../domain/entities/ticket_request.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/trip_route_entity.dart';
import '../../domain/repositories/trips_repository.dart';
import '../datasources/trips_remote_datasource.dart';
import '../models/trip_model.dart';
import '../models/trip_route_model.dart';

class TripsRepositoryImpl implements TripsRepository {
  const TripsRepositoryImpl(this.remote);

  final TripsRemoteDataSource remote;

  @override
  ResultFuture<List<TripEntity>> fetchTripsByStations({
    String? startStationId,
    String? endStationId,
    int page = 1,
    int pageSize = 5,
    required String token,
  }) async {
    try {
      final response = await remote.fetchTripsByStations(
        startStationId: startStationId,
        endStationId: endStationId,
        page: page,
        pageSize: pageSize,
        token: token,
      );

      final data = response.data;
      if (data is List) {
        return Right(data
            .whereType<Map>()
            .map((e) => TripModel.fromJson(e.cast<String, dynamic>()))
            .toList());
      }
      if (data is Map && data['data'] is List) {
        return Right((data['data'] as List)
            .whereType<Map>()
            .map((e) => TripModel.fromJson(e.cast<String, dynamic>()))
            .toList());
      }

      throw {
        'message': 'Invalid trips response',
        'statusCode': response.statusCode ?? 500,
      };
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultFuture<List<TripRouteEntity>> fetchTripRoutes({
    required String tripId,
    required String token,
  }) async {
    try {
      final response = await remote.fetchTripRoutes(tripId: tripId, token: token);
      final data = response.data;

      if (data is List) {
        return Right(data
            .whereType<Map>()
            .map((e) => TripRouteModel.fromJson(e.cast<String, dynamic>()))
            .toList());
      }

      throw {
        'message': 'Invalid trip routes response',
        'statusCode': response.statusCode ?? 500,
      };
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultFuture<Map<String, dynamic>> fetchTripDetails({
    required String tripId,
    required String token,
  }) async {
    try {
      final response = await remote.fetchTripDetails(tripId: tripId, token: token);
      final data = response.data;

      if (data is Map<String, dynamic>) {
        return Right(data);
      }
      if (data is Map) {
        return Right(data.cast<String, dynamic>());
      }

      throw {
        'message': 'Invalid trip details response',
        'statusCode': response.statusCode ?? 500,
      };
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultFuture<void> createTicket({required TicketRequest request, required String token}) async {
    try {
      await remote.createTicket(body: request.toJson(), token: token);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultFuture<void> cancelTicket({required int tripId, required String token}) async {
    try {
      await remote.cancelTicket(tripId: tripId, token: token);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultFuture<void> updateTicketState({required int tripRouteId, required String token}) async {
    try {
      await remote.updateTicketState(tripRouteId: tripRouteId, token: token);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(dynamic e) {
    if (e is Map && e['message'] != null) {
      return ApiFailure(
        message: e['message'].toString(),
        statusCode: (e['statusCode'] as int?) ?? 500,
      );
    }
    if (e is DioException) {
      final errorData = e.response?.data;
      if (errorData is Map && errorData['message'] != null) {
        return ApiFailure(
          message: errorData['message'].toString(),
          statusCode: e.response?.statusCode ?? 500,
        );
      }
      return ApiFailure(
        message: e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
    return ApiFailure(message: e.toString(), statusCode: 500);
  }
}

