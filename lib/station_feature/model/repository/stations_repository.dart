import 'package:dio/dio.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:logger/logger.dart';

class StationsRepository {
  final ApiService _apiService = ApiService();
  final Logger logger = Logger();

  // دالة API موحدة تبني الـ URL بناءً على قيمة inUOT و search
  Future<Response> fetchStations({String? inUOT, String? search}) async {
    try {
      String endpoint = 'stations';
      Map<String, dynamic> queryParameters = {};

      if (inUOT != null && inUOT.isNotEmpty) {
        queryParameters['inUOT'] = inUOT;
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      if (queryParameters.isNotEmpty) {
        final queryString = Uri(queryParameters: queryParameters).query;
        endpoint = '$endpoint?$queryString';
      }
      logger.i('Constructed endpoint: $endpoint');
      final response = await _apiService.getRequest(endpoint);
      logger.i('Stations fetched successfully');
      return response;
    } on DioError catch (e) {
      logger.e('DioError in fetchStations: ${e.message}');
      rethrow;
    }
  }
}