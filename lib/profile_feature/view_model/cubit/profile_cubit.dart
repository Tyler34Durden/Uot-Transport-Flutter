//added after removed
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:uot_transport/profile_feature/model/repository/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final Logger _logger = Logger();

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  // جلب بيانات الملف الشخصي
  Future<void> fetchUserProfile(String token, int userId) async {
    emit(ProfileLoading());
    try {
      final profileData = await _profileRepository.fetchUserProfile(token, userId);
      emit(ProfileSuccess(profileData));
    } on DioException catch (e) {
      _logger.e('Error fetching user profile: ${e.message}');
      final errorData = e.response?.data;
      if (errorData is Map && errorData['message'] != null) {
        emit(ProfileFailure(errorData['message']));
      } else {
        emit(ProfileFailure(e.toString()));
      }
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
    } on DioException catch (e) {
      _logger.e('Error updating user phone: ${e.message}');
      final errorData = e.response?.data;
      if (errorData is Map && errorData['message'] != null) {
        emit(ProfileFailure(errorData['message']));
      } else {
        emit(ProfileFailure(e.toString()));
      }
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
    } on DioException catch (e) {
      _logger.e('Error changing password: ${e.message}');
      final errorData = e.response?.data;
      if (errorData is Map && errorData['message'] != null) {
        emit(ProfileFailure(errorData['message']));
      } else {
        emit(ProfileFailure(e.toString()));
      }
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> logout(String token) async {
    emit(ProfileLoading());
    try {
      await _profileRepository.logout(token);
      emit(ProfileSuccess({'message': 'Logout successful'}));
    } on DioException catch (e) {
      _logger.e('Error during logout: ${e.message}');
      final errorData = e.response?.data;
      if (errorData is Map && errorData['message'] != null) {
        emit(ProfileFailure(errorData['message']));
      } else {
        emit(ProfileFailure(e.toString()));
      }
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}