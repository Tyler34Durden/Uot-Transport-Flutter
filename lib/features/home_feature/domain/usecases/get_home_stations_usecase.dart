import 'package:uot_transport/core/utilities.dart';

import '../../../station_feature/domain/entities/station_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeStationsUseCase {
  const GetHomeStationsUseCase(this.repository);
  final HomeRepository repository;

  ResultFuture<List<StationEntity>> call({required String token}) {
    return repository.getStations(token: token);
  }
}

