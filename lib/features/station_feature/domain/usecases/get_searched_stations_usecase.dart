import 'package:uot_transport/core/usecase/usecase.dart';
import 'package:uot_transport/core/utilities.dart';

import '../repositories/station_repositories.dart';

class GetSearchedStationsParams {
  const GetSearchedStationsParams({
    required this.name,
    this.location = '',
  });

  final String name;
  final String location;
}

class GetSearchedStationsUseCase
    extends UsecaseWithParams<dynamic, GetSearchedStationsParams> {
  const GetSearchedStationsUseCase(this._repository);

  final StationRepository _repository;

  @override
  ResultFuture<dynamic> call(GetSearchedStationsParams params) {
    return _repository.getSearchedStations(params.name, params.location);
  }
}
