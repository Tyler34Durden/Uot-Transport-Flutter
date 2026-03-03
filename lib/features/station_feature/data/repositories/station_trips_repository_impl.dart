import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/core/utilities.dart';
import 'package:uot_transport/features/station_feature/data/datasources/station_trips_remote_datasource.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_trip_entity.dart';
import 'package:uot_transport/features/station_feature/domain/repositories/station_trips_repository.dart';

class StationTripsRepositoryImpl implements StationTripsRepository {
  const StationTripsRepositoryImpl(this._remote);

  final StationTripsRemoteDataSource _remote;

  @override
  ResultFuture<List<StationTripEntity>> getStationTrips({
    required int stationId,
    required String token,
  }) async {
    try {
      final trips = await _remote.getStationTrips(stationId: stationId, token: token);
      return Right(trips);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : e.message ?? e.toString();
      return Left(ApiFailure(message: message, statusCode: e.response?.statusCode ?? 500));
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }
}

