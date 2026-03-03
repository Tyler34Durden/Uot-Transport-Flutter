import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/core/utilities.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';

abstract class StationRepository {
  ResultFuture<List<StationEntity>> getStations();
  ResultFuture<List<StationEntity>> getSearchedStations(String name, String location);
}