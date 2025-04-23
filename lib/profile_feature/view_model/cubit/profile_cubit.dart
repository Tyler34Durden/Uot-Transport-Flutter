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
 // دالة تحديث رقم الهاتف باستخدام API الجديد
  Future<void> updateUserPhone(String token, Map<String, dynamic> updatedData) async {
    emit(ProfileLoading());
    try {
      final profileData = await _profileRepository.updateUserPhone(token, updatedData);
      emit(ProfileSuccess(profileData));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
   // دالة تغيير كلمة المرور
  Future<void> changePassword(String token, Map<String, dynamic> passwordData) async {
    emit(ProfileLoading());
    try {
      final responseData = await _profileRepository.changePassword(token, passwordData);
      emit(ProfileSuccess(responseData));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}