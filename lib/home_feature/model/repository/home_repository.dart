import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class HomeRepository {
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

  Future<List<Map<String, dynamic>>> fetchAdvertisings() async {
    try {
      final response = await _apiService.getRequest('advertisings');
      logger.i('Advertisings fetched successfully');
      if (response.data != null && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((ad) => ad as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Invalid response structure: Missing "data" key');
      }
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}