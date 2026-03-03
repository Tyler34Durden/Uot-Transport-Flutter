// Manually created Mockito mock for StationRepository.
//
// This avoids requiring build_runner/codegen for this repo's current test setup.
// If you later adopt codegen, delete this file and generate mocks using @GenerateMocks.

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';
import 'package:uot_transport/features/station_feature/domain/repositories/station_repositories.dart';

class MockStationRepository extends Mock implements StationRepository {
  @override
  Future<Either<Failure, List<StationEntity>>> getStations() => super.noSuchMethod(
        Invocation.method(#getStations, const []),
        returnValue: Future.value(
          const Right<Failure, List<StationEntity>>(<StationEntity>[]),
        ),
        returnValueForMissingStub: Future.value(
          const Right<Failure, List<StationEntity>>(<StationEntity>[]),
        ),
      ) as Future<Either<Failure, List<StationEntity>>>;

  @override
  Future<Either<Failure, List<StationEntity>>> getSearchedStations(
    String name,
    String location,
  ) =>
      super.noSuchMethod(
        Invocation.method(#getSearchedStations, [name, location]),
        returnValue: Future.value(
          const Right<Failure, List<StationEntity>>(<StationEntity>[]),
        ),
        returnValueForMissingStub: Future.value(
          const Right<Failure, List<StationEntity>>(<StationEntity>[]),
        ),
      ) as Future<Either<Failure, List<StationEntity>>>;
}
