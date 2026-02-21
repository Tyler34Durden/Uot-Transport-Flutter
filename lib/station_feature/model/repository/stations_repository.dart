import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class StationsRepository {
  final ApiService _apiService;
  final Logger logger = Logger();

  StationsRepository(this._apiService);

  Future<Response> fetchStations({int page = 1, int pageSize = 20}) async {
    try {
      final endpoint = 'stations?page=$page&pageSize=$pageSize';
      final response = await _apiService.getRequest(endpoint);
      logger.i('Stations fetched successfully');
      return response;
    } on DioException catch (e) {
      logger.e('DioException in fetchStations: ${e.message}');
      if (e.response != null) {
        logger.e('DioException Response: ${e.response?.data}');
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
    } on DioException catch (e) {
      logger.e('DioException in fetchFilteredStations: ${e.message}');
      if (e.response != null) {
        logger.e('DioException Response: ${e.response?.data}');
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
    } on DioException catch (e) {
      logger.e('DioException during searchStations: ${e.message}');
      if (e.response != null) {
        logger.e('DioException Response during searchStations: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
