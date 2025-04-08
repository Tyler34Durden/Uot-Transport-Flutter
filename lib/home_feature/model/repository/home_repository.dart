import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class TripsRepository {
  final ApiService _apiService = ApiService();
  final logger = Logger();

  Future<List<dynamic>> fetchTodayTrips() async {
    try {
      final response = await _apiService.getRequest('trips/today');
      logger.i('Trips fetched successfully');
      return response.data;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  // Future<Response> fetchTripDetails(int tripId) async {
  //   try {
  //     final response = await _apiService.getRequest('trips/$tripId');
  //     logger.i('Trip details fetched successfully for tripId: $tripId');
  //     return response;
  //   } on DioError catch (e) {
  //     logger.e('DioError: ${e.message}');
  //     if (e.response != null) {
  //       logger.e('DioError Response: ${e.response?.data}');
  //     }
  //     rethrow;
  //   }
  // }
}