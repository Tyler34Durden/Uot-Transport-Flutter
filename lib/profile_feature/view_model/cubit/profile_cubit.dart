import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'profile_state.dart';
import 'package:uot_transport/profile_feature/model/repository/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final Logger _logger = Logger();

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  Future<void> fetchUserProfile(String token, int userId) async {
    emit(ProfileLoading());
    try {
      final response = await _profileRepository.fetchUserProfile(token, userId);
      final data = response.data;
      if (data is Map && data['message'] == 'success' && data['data'] != null) {
        emit(ProfileSuccess(data['data']));
      } else {
        throw Exception('Invalid profile response');
      }
    } catch (e) {
      _logger.e('Error while fetching profile: $e');
      emit(ProfileFailure(e.toString()));
    }
  }

 Future<void> updateUserProfile(
    String token,
    int userId,
    Map<String, dynamic> payload,
  ) async {
    emit(ProfileLoading()); // يمكن استخدام حالة خاصة بالتحديث إن أردت
    try {
      final response = await _profileRepository.updateUserProfile(token, userId, payload);
      final data = response.data;
      if (data is Map && data['message'] == 'success') {
        // في حال نجح التحديث، يمكننا إعادة جلب الملف الشخصي مثلاً
        fetchUserProfile(token, userId);
      } else {
        throw Exception('Update profile failed');
      }
    } catch (e) {
      _logger.e('Error while updating profile: $e');
      emit(ProfileFailure(e.toString()));
    }
  }





}