import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class StationsRepository {
  final ApiService _apiService = ApiService();
  final Logger logger = Logger();

  Future<Response> fetchStations({int page = 1, int pageSize = 20}) async {
    try {
      final endpoint = 'stations?page=$page&pageSize=$pageSize';
      final response = await _apiService.getRequest(endpoint);
      logger.i('Stations fetched successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError in fetchStations: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> fetchFilteredStations(bool inUot, {int page = 1, int pageSize = 20}) async {
    try {
      final endpoint = 'stations?inUOT=$inUot&page=$page&pageSize=$pageSize';
      final response = await _apiService.getRequest(endpoint);
      logger.i('Filtered stations fetched successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError in fetchFilteredStations: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> searchStations(String stationName, {bool? inUot, int page = 1, int pageSize = 20}) async {
    try {
      String endpoint = 'stations?search=$stationName&page=$page&pageSize=$pageSize';
      if (inUot != null) {
        endpoint += '&inUOT=${inUot ? 1 : 0}';
      }
      final response = await _apiService.getRequest(endpoint);
      logger.i('Search stations fetched successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError during searchStations: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response during searchStations: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
