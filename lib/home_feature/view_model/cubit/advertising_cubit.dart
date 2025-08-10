
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/home_feature/model/repository/home_repository.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_state.dart';

class AdvertisingsCubit extends Cubit<AdvertisingsState> {
  final HomeRepository _repository;
  final Logger _logger = Logger();

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
          'description': ad['description']?.toString() ?? '',
        };
      }).toList();
      emit(AdvertisingsLoaded(transformedAdvertisings));
    } on DioException catch (e) {
      _logger.e('Error while fetching advertisings: $e');
      final errorData = e.response?.data;
      if (errorData is Map && errorData['message'] != null) {
        emit(AdvertisingsError(errorData['message']));
      } else {
        emit(AdvertisingsError(e.toString()));
      }
      emit(AdvertisingsError('Failed to fetch advertisings: ${e.toString()}'));
    }
  }
}