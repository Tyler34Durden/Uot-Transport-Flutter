import 'package:uot_transport/core/api_service.dart';
import 'package:uot_transport/features/station_feature/data/datasources/station_remote_datasource.dart';
import 'package:uot_transport/features/station_feature/data/models/station_model.dart';
import 'package:uot_transport/core/utilities.dart';

class StationRemoteDataSourceImpl implements StationRemoteDataSource {
  const StationRemoteDataSourceImpl(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<StationModel>> getStations() async {
    final response = await _apiService.getRequest(
      'stations',
      queryParams: const {
        'page': 1,
        'pageSize': 20,
      },
    );

    final data = response.data;
    final list = (data is Map<String, dynamic>) ? (data['data'] as List?) : null;

    if (list == null) return const [];

    return list
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final stationMap = (e['station'] is Map<String, dynamic>)
              ? (e['station'] as Map<String, dynamic>)
              : e;
          return StationModel.fromMap(stationMap);
        })
        .toList(growable: false);
  }

  @override
  Future<List<StationModel>> getSearchedStations({
    required String name,
    required String location,
  }) async {
    final response = await _apiService.getRequest(
      'stations',
      queryParams: {
        'search': name,
        'page': 1,
        'pageSize': 20,
      },
    );

    final data = response.data;
    final list = (data is Map<String, dynamic>) ? (data['data'] as List?) : null;

    if (list == null) return const [];

    return list
        .whereType<Map<String, dynamic>>()
        .map((e) {
          final stationMap = (e['station'] is Map<String, dynamic>)
              ? (e['station'] as Map<String, dynamic>)
              : e;
          return StationModel.fromMap(stationMap);
        })
        .toList(growable: false);
  }
}
