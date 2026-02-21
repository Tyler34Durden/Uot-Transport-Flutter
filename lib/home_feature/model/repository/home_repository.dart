import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class HomeRepository {
  final ApiService _apiService;
  final Logger logger = Logger();

  HomeRepository(this._apiService);

  Future<List<dynamic>> fetchTodayTrips({int? stationId,
    required String token,

  }) async {
    try {
      final Map<String, dynamic> queryParams =
          stationId != null ? {'stationId': stationId} : {};
      final response =
          await _apiService.getRequest('trips/today', queryParams: queryParams,token: token);
      logger.i('Today\'s trips fetched successfully');
      return response.data ?? [];
    } on DioException catch (e) {
      logger.e('DioException in fetchTodayTrips: ${e.message}');
      if (e.response != null) {
        logger.e('DioException Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAdvertisings(
      String token,
      ) async {
    try {
      final response = await _apiService.getRequest('advertisings',token: token);
      logger.i('Advertisings fetched successfully');
      if (response.data != null && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((ad) => ad as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Invalid response structure: Missing "data" key');
      }
    } on DioException catch (e) {
      logger.e('DioException in fetchAdvertisings: ${e.message}');
      if (e.response != null) {
        logger.e('DioException Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchStations(String token,) async {
    try {
      final response = await _apiService.getRequest('stations/filter',token: token);
      logger.i('Stations fetched successfully');
      if (response.data != null && response.data is List) {
        return (response.data as List)
            .map((station) => station as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Invalid response structure: Expected a list of stations');
      }
    } on DioException catch (e) {
      logger.e('DioException in fetchStations: ${e.message}');
      if (e.response != null) {
        logger.e('DioException Response: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchMyTrips(String token) async {
    try {
      final response = await _apiService.getRequest(
        'tickets/myTickets',
        token: token, // Pass the Bearer token here
      );
      logger.i('My Trips fetched successfully');
      if (response.data != null && response.data is List) {
        return (response.data as List)
            .map((trip) => trip as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Invalid response structure: Expected a list of trips');
      }
    } on DioException catch (e) {
      logger.e('DioException in fetchMyTrips: ${e.message}');
      if (e.response != null) {
        logger.e('DioException Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
