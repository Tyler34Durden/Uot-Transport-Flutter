import 'package:dio/dio.dart';

import '../../../../core/api_service.dart';

class HomeRemoteDataSource {
  const HomeRemoteDataSource(this.apiService);

  final ApiService apiService;

  Future<Response> fetchTodayTrips({int? stationId, required String token}) {
    final queryParams = stationId != null ? {'stationId': stationId} : <String, dynamic>{};
    return apiService.getRequest('trips/today', queryParams: queryParams, token: token);
  }

  Future<Response> fetchAdvertisings({required String token}) {
    return apiService.getRequest('advertisings', token: token);
  }

  Future<Response> fetchStations({required String token}) {
    return apiService.getRequest('stations/filter', token: token);
  }

  Future<Response> fetchMyTrips({required String token}) {
    return apiService.getRequest('tickets/myTickets', token: token);
  }
}

