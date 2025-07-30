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
            int page = 1,
            int pageSize = 5,
            required String token,
          }) async {
            try {
              // Build the filter part of the URL based on which IDs are provided
              String filterPart;
              if (startStationId != null && endStationId != null) {
                filterPart = '$startStationId/$endStationId';
              } else if (startStationId != null) {
                filterPart = '$startStationId/null';
              } else if (endStationId != null) {
                filterPart = 'null/$endStationId';
              } else {
                filterPart = 'null/null';
              }
              final String url = "tripRoutes/filter/$filterPart?page=$page&pageSize=$pageSize";
              final response = await _apiService.getRequest(url, token: token);
              logger.i('Trips fetched successfully: ${response.data}');
              dynamic responseData = response.data;
              if (responseData is List) {
                return responseData.cast<Map<String, dynamic>>();
              } else if (responseData is Map && responseData['data'] is List) {
                return (responseData['data'] as List).cast<Map<String, dynamic>>();
              } else {
                throw Exception('Invalid data format in trips response');
              }
            } on DioError catch (e) {
              final backendMessage = e.response?.data?['message']?.toString();
              logger.e('Error fetching trips: ${backendMessage ?? e.message}');
              rethrow;
            }
          }

          Future<List<Map<String, dynamic>>> fetchTripRoutes(
              String tripID,
              String token,

              ) async {
            try {
              final String url = "tripRoutes/trip/$tripID";
              final response = await _apiService.getRequest(url,token: token);
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

          Future<Map<String, dynamic>> fetchTripDetailsScreen(String tripID,String token,) async {
            try {
              final String url = "trip/$tripID/mobile";
              final response = await _apiService.getRequest(url,token: token);
              logger.i('Trip details (API) fetched successfully: ${response.data}');
              dynamic responseData = response.data;
              if (responseData is Map<String, dynamic>) {
                return responseData;
              } else {
                throw Exception('Invalid data format in trip details response');
              }
            } on DioError catch (e) {
              logger.e('Error fetching trip details from API: ${e.message}');
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

          Future<void> cancelTicket({
            required int tripId,
            required String token,
          }) async {
            try {
              final String url = "ticket/$tripId/cancel";
              final response = await _apiService.patchRequest(url, {}, token: token);
              logger.i('Ticket cancelled successfully: ${response.data}');
            } on DioError catch (e) {
              logger.e('Error cancelling ticket: ${e.message}');
              if (e.response != null) {
                logger.e('DioError Response: ${e.response?.data}');
              }
              rethrow;
            }
          }


          Future<void> updateTicketState({
            required int tripRouteId,
            required String token,
          }) async {
            try {
              final String url = "ticket/updateState/$tripRouteId";
              final response = await _apiService.putRequest(url, {}, token: token);
              logger.i('Ticket state updated successfully: ${response.data}');
            } on DioError catch (e) {
              logger.e('Error updating ticket state: ${e.message}');
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