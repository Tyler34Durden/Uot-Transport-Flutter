import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/utilities.dart';
import 'package:uot_transport/features/station_feature/data/datasources/station_remote_datasource.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';
import 'package:uot_transport/features/station_feature/domain/repositories/station_repositories.dart';
import 'package:uot_transport/core/error/failures.dart';

class StationRepositoryImpl implements StationRepository {
  const StationRepositoryImpl(this._remote);
  final StationRemoteDataSource _remote;

  @override
  ResultFuture<List<StationEntity>> getSearchedStations(
    String name,
    String location,
  ) async {
    try {
      final stations = await _remote.getSearchedStations(name: name,location: location);
      // StationModel extends StationEntity, so this is safe.
      return Right(stations);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }

  @override
  ResultFuture<List<StationEntity>> getStations() async {
    try {
      final stations = await _remote.getStations();
      return Right(stations);
    } catch (e) {
      return Left(ApiFailure(message: e.toString(), statusCode: 500));
    }
  }
}