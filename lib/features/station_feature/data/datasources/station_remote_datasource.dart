import 'package:uot_transport/features/station_feature/data/models/station_model.dart';

abstract class StationRemoteDataSource {
  Future<List<StationModel>> getStations();
  Future<List<StationModel>> getSearchedStations({
      required String name,
    required String location});
}