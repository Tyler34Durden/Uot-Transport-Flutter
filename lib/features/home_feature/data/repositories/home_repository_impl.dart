import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/core/utilities.dart';

import '../../../station_feature/data/models/station_model.dart';
import '../../../station_feature/domain/entities/station_entity.dart';
import '../../domain/entities/advertising_entity.dart';
import '../../domain/entities/home_trip_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/advertising_model.dart';
import '../models/home_trip_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this.remote);

  final HomeRemoteDataSource remote;

  @override
  ResultFuture<List<AdvertisingEntity>> getAdvertisings({required String token}) async {
    try {
      final response = await remote.fetchAdvertisings(token: token);
      final data = response.data;

      if (data is Map && data['data'] is List) {
        final list = (data['data'] as List)
            .whereType<Map>()
            .map((e) => AdvertisingModel.fromJson(e.cast<String, dynamic>()))
            .toList();
        return Right(list);
      }

      throw {
        'message': 'Invalid advertisings response',
        'statusCode': response.statusCode ?? 500,
      };
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultFuture<List<StationEntity>> getStations({required String token}) async {
    try {
      final response = await remote.fetchStations(token: token);
      final data = response.data;

      if (data is List) {
        final list = data
            .whereType<Map>()
            .map((e) => StationModel.fromMap(e.cast<String, dynamic>()))
            .toList();
        return Right(list);
      }

      throw {
        'message': 'Invalid stations response',
        'statusCode': response.statusCode ?? 500,
      };
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultFuture<List<HomeTripEntity>> getMyTrips({required String token}) async {
    try {
      final response = await remote.fetchMyTrips(token: token);
      final data = response.data;

      if (data is List) {
        final list = data
            .whereType<Map>()
            .map((e) => HomeTripModel.fromJson(e.cast<String, dynamic>()))
            .toList();
        return Right(list);
      }

      throw {
        'message': 'Invalid my trips response',
        'statusCode': response.statusCode ?? 500,
      };
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultFuture<List<HomeTripEntity>> getTodayTrips({int? stationId, required String token}) async {
    try {
      final response = await remote.fetchTodayTrips(stationId: stationId, token: token);
      final data = response.data;

      if (data is List) {
        final list = data
            .whereType<Map>()
            .map((e) => HomeTripModel.fromJson(e.cast<String, dynamic>()))
            .toList();
        return Right(list);
      }

      // Some backends wrap today trips in {data:[...]}
      if (data is Map && data['data'] is List) {
        final list = (data['data'] as List)
            .whereType<Map>()
            .map((e) => HomeTripModel.fromJson(e.cast<String, dynamic>()))
            .toList();
        return Right(list);
      }

      throw {
        'message': 'Invalid today trips response',
        'statusCode': response.statusCode ?? 500,
      };
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

