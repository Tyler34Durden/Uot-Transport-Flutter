import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uot_transport/features/station_feature/domain/entities/station_entity.dart';
import 'package:uot_transport/features/station_feature/domain/usecases/get_stations_usecase.dart';

import 'station_repository.mocks.dart';

void main() {
  late GetStationsUseCase usecase;
  late MockStationRepository mockStationRepository;

  setUp(() {
    mockStationRepository = MockStationRepository();
    usecase = GetStationsUseCase(mockStationRepository);
  });

  const stationEntity = StationEntity(id: 1, name: 'Station Name', location: 'Station Location');
  const stations = <StationEntity>[stationEntity];

  test('should get stations from the repository', () async {
    // Arrange
    when(mockStationRepository.getStations()).thenAnswer((_) async => Right(stations));

    // Act
    final result = await usecase();

    // Assert
    expect(result, Right(stations));
    verify(mockStationRepository.getStations()).called(1);
    verifyNoMoreInteractions(mockStationRepository);
  });
}
