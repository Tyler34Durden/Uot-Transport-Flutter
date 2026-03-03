import 'package:uot_transport/core/utilities.dart';

import '../entities/advertising_entity.dart';
import '../repositories/home_repository.dart';

class GetAdvertisingsUseCase {
  const GetAdvertisingsUseCase(this.repository);
  final HomeRepository repository;

  ResultFuture<List<AdvertisingEntity>> call({required String token}) {
    return repository.getAdvertisings(token: token);
  }
}

