// File: lib/trips_feature/model/repository/trips_repository.dart
        import 'package:dio/dio.dart';
        import 'package:uot_transport/core/api_service.dart';
        import 'package:logger/logger.dart';

        class TripsRepository {
          final ApiService _apiService = ApiService();
          final Logger logger = Logger();

          Future<List<Map<String, dynamic>>> fetchTripsByStations({
            String? startStationId,
            String? endStationId,
          }) async {
            try {
              final String id1 = startStationId ?? "null";
              final String id2 = endStationId ?? "null";
              final String url = "tripRoutes/filter/$id1/$id2";
              final response = await _apiService.getRequest(url);
              logger.i('Trips fetched successfully: ${response.data}');
              dynamic responseData = response.data;
              if (responseData is List) {
                return responseData.cast<Map<String, dynamic>>();
              } else if (responseData is Map && responseData['data'] is List) {
                return (responseData['data'] as List).cast<
                    Map<String, dynamic>>();
              } else {
                throw Exception('Invalid data format in trips response');
              }
            } on DioError catch (e) {
              logger.e('Error fetching trips: ${e.message}');
              rethrow;
            }
          }

          Future<List<Map<String, dynamic>>> fetchTripRoutes(
              String tripID) async {
            try {
              final String url = "tripRoutes/trip/$tripID";
              final response = await _apiService.getRequest(url);
              logger.i('Trip routes fetched successfully: ${response.data}');
              dynamic responseData = response.data;
              if (responseData is List) {
                return responseData.cast<Map<String, dynamic>>();
              } else {
                throw Exception('Invalid data format in trip routes response');
              }
            } on DioError catch (e) {
              logger.e('Error fetching trip details: ${e.message}');
              if (e.response != null) {
                logger.e('DioError Response: ${e.response?.data}');
              }
              rethrow;
            }
          }

          Future<void> createTicket({
            required int tripID,
            required int fromTripRoute,
            required int toTripRoute,
            required String token,
          }) async {
            try {
              final String url = "ticket";
              final Map<String, dynamic> requestData = {
                "tripID": tripID,
                "fromTripRoute": fromTripRoute,
                "toTripRoute": toTripRoute,
              };

              final response = await _apiService.postRequest(
                  url, requestData, token: token);
              logger.i('Ticket created successfully: ${response.data}');
            } on DioError catch (e) {
              logger.e('Error creating ticket: ${e.message}');
              if (e.response != null) {
                logger.e('DioError Response: ${e.response?.data}');
              }
              rethrow;
            }
          }


        // Future<Response> fetchStations() async {
        //   try {
        //     final response = await _apiService.getRequest('stations');
        //     logger.i('Stations fetched successfully');
        //     return response;
        //   } on DioError catch (e) {
        //     logger.e('DioError in fetchStations: ${e.message}');
        //     rethrow;
        //   }
        // }
        }