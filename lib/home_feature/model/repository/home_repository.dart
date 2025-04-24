import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();
  final logger = Logger();

Future<List<dynamic>> fetchTodayTrips({int? stationId}) async {
  final Map<String, dynamic> queryParams = stationId != null ? {'stationId': stationId} : {};
  final response = await _apiService.getRequest('trips/today', queryParams: queryParams);
  return response.data;
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

Future<List<Map<String, dynamic>>> fetchStations() async {
    try {
      final response = await _apiService.getRequest('stations/filter');
      logger.i('Stations fetched successfully');

      // Parse the response as a list of maps
      if (response.data != null && response.data is List) {
        return (response.data as List)
            .map((station) => station as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Invalid response structure: Expected a list of stations');
      }
    } on DioError catch (e) {
      logger.e('DioError in fetchStations: ${e.message}');
      if (e.response != null) {
        logger.e('DioError Response: ${e.response?.data}');
      }
      rethrow;
    }
  }}