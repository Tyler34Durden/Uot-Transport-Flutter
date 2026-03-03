import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/core/usecase/usecase.dart';
import 'package:uot_transport/core/utilities.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';
import 'package:uot_transport/features/station_feature/domain/repositories/station_repositories.dart';

class GetStationsUseCase extends UsecaseWithoutParams<List<StationEntity>> {
  const GetStationsUseCase(this._repository);
  final StationRepository _repository;

  @override
  ResultFuture<List<StationEntity>> call() async =>
      _repository.getStations();
}
