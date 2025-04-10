import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class StationsRepository {
  final ApiService _apiService = ApiService();
  final logger = Logger();

  Future<Response> fetchStations() async {
    try {
      final response = await _apiService.getRequest('stations');
      logger.i('Stations fetched successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> fetchFilteredStations(bool inUot) async {
    try {
      final endpoint = 'stations/inUot/$inUot/mobile';
      final response = await _apiService.getRequest(endpoint);
      logger.i('Filtered stations fetched successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
   Future<Response> searchStations(String stationName) async {
    try {
      final endpoint = 'stations/search/$stationName';
      final response = await _apiService.getRequest(endpoint);
      logger.i('Search stations fetched successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError during search: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response during search: ${e.response?.data}');
      }
      rethrow;
    }
  }
}