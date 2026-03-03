import 'package:dio/dio.dart';

import '../../../../core/api_service.dart';

class TripsRemoteDataSource {
  const TripsRemoteDataSource(this.apiService);

  final ApiService apiService;

  Future<Response> fetchTripsByStations({
    String? startStationId,
    String? endStationId,
    int page = 1,
    int pageSize = 5,
    required String token,
  }) {
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

    final url = 'tripRoutes/filter/$filterPart?page=$page&pageSize=$pageSize';
    return apiService.getRequest(url, token: token);
  }

  Future<Response> fetchTripRoutes({required String tripId, required String token}) {
    return apiService.getRequest('tripRoutes/trip/$tripId', token: token);
  }

  Future<Response> fetchTripDetails({required String tripId, required String token}) {
    return apiService.getRequest('trip/$tripId/mobile', token: token);
  }

  Future<Response> createTicket({required Map<String, dynamic> body, required String token}) {
    return apiService.postRequest('ticket', body, token: token);
  }

  Future<Response> cancelTicket({required int tripId, required String token}) {
    return apiService.patchRequest('ticket/$tripId/cancel', {}, token: token);
  }

  Future<Response> updateTicketState({required int tripRouteId, required String token}) {
    return apiService.putRequest('ticket/updateState/$tripRouteId', {}, token: token);
  }
}

