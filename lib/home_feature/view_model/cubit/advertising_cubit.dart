
import 'package:bloc/bloc.dart';
import 'package:uot_transport/home_feature/model/repository/home_repository.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_state.dart';

class AdvertisingsCubit extends Cubit<AdvertisingsState> {
  final HomeRepository _repository;

  AdvertisingsCubit(this._repository) : super(AdvertisingsInitial());

  Future<void> fetchAdvertisings(String token) async {
    emit(AdvertisingsLoading());
    try {
      final advertisings = await _repository.fetchAdvertisings(token);
      // Transform the data to List<Map<String, dynamic>>
      final transformedAdvertisings = advertisings.map<Map<String, dynamic>>((ad) {
        return {
          'photo': ad['photo']?.toString() ?? '',
          'title': ad['title']?.toString() ?? '',
        };
      }).toList();
      emit(AdvertisingsLoaded(transformedAdvertisings));
    } catch (e) {
      emit(AdvertisingsError('Failed to fetch advertisings: ${e.toString()}'));
    }
  }
}