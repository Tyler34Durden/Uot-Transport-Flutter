import 'package:bloc/bloc.dart';
import 'package:uot_transport/profile_feature/model/repository/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  // جلب بيانات الملف الشخصي
  Future<void> fetchUserProfile(String token, int userId) async {
    emit(ProfileLoading());
    try {
      final profileData = await _profileRepository.fetchUserProfile(token, userId);
      emit(ProfileSuccess(profileData));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  // تعديل بيانات الملف الشخصي
  Future<void> updateUserProfile(String token, int userId, Map<String, dynamic> updatedData) async {
    emit(ProfileLoading());
    try {
      final profileData = await _profileRepository.updateUserProfile(token, userId, updatedData);
      emit(ProfileSuccess(profileData));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}