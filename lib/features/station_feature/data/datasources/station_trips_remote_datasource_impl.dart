import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:uot_transport/features/station_feature/data/datasources/station_trips_remote_datasource.dart';
import 'package:uot_transport/features/station_feature/data/models/station_trip_model.dart';

class StationTripsRemoteDataSourceImpl implements StationTripsRemoteDataSource {
  StationTripsRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;
  final Logger _logger = Logger();

  @override
  Future<List<StationTripModel>> getStationTrips({
    required int stationId,
    required String token,
  }) async {
    try {
      final endpoint = 'station/$stationId/trips';
      final response = await _apiService.getRequest(endpoint, token: token);

      final data = response.data;
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(StationTripModel.fromMap)
            .toList(growable: false);
      }

      if (data is Map<String, dynamic>) {
        return [StationTripModel.fromMap(data)];
      }

      _logger.w('Unexpected station trips response type: ${data.runtimeType}');
      return const [];
    } on DioException {
      rethrow;
    }
  }
}

