//added after removed
import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class StationTripsRepository {
  final ApiService _apiService = ApiService();
  final Logger logger = Logger();

  Future<Response> fetchStationTrips(int stationId) async {
    try {
      final endpoint = 'station/$stationId/trips';
      final response = await _apiService.getRequest(endpoint);
      logger.i('Station trips fetched successfully for stationId: $stationId');
      return response;
    } on DioError catch (e) {
      logger.e('DioError in fetchStationTrips: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}