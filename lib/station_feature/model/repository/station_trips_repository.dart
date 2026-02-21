import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class StationTripsRepository {
  final ApiService _apiService;
  final Logger logger = Logger();

  StationTripsRepository(this._apiService);

  // Fetch trips for a specific station
  Future<Response> fetchStationTrips(int stationId, String token) async {
    try {
      final endpoint = 'station/$stationId/trips';
      final response = await _apiService.getRequest(endpoint, token: token);
      logger.i(
        'Station trips fetched successfully for stationId: $stationId',
      );
      return response;
    } on DioException catch (e) {
      logger.e('DioException in fetchStationTrips: ${e.message}');
      if (e.response != null) {
        logger.e('DioException Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
