import 'package:uot_transport/core/utilities.dart';

import '../entities/home_trip_entity.dart';
import '../repositories/home_repository.dart';

class GetMyTripsUseCase {
  const GetMyTripsUseCase(this.repository);
  final HomeRepository repository;

  ResultFuture<List<HomeTripEntity>> call({required String token}) {
    return repository.getMyTrips(token: token);
  }
}

