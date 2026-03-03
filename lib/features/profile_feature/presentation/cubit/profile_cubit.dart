import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/update_phone_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ProfileRepository repository,
    required UpdatePhoneUseCase updatePhone,
    required ChangePasswordUseCase changePassword,
    required LogoutUseCase logout,
  })  : _repo = repository,
        _updatePhone = updatePhone,
        _changePassword = changePassword,
        _logout = logout,
        super(const ProfileState.initial());

  final ProfileRepository _repo;
  final UpdatePhoneUseCase _updatePhone;
  final ChangePasswordUseCase _changePassword;
  final LogoutUseCase _logout;

  Future<void> loadCached() async {
    emit(const ProfileState.loading());
    final tokenRes = await _repo.getToken();
    final token = tokenRes.fold((_) => null, (t) => t);
    if (token == null || token.isEmpty) {
      emit(const ProfileState.error(message: 'غير موثق. تحتاج إلى تسجيل الدخول.'));
      return;
    }

    final cachedRes = await _repo.getCachedUserProfile();
    cachedRes.fold(
      (_) => emit(const ProfileState.error(message: 'بيانات المستخدم غير موجودة، يرجى إعادة تسجيل الدخول.')),
      (profile) {
        if (profile == null) {
          emit(const ProfileState.error(message: 'بيانات المستخدم غير موجودة، يرجى إعادة تسجيل الدخول.'));
        } else {
          emit(ProfileState.loaded(profile: profile));
        }
      },
    );
  }

  Future<void> updatePhone(String phone) async {
    emit(const ProfileState.loading());
    final res = await _updatePhone(phone);
    res.fold(
      (f) => emit(ProfileState.error(message: f.message)),
      (p) => emit(ProfileState.actionSuccess(message: 'تم حفظ التغييرات بنجاح!', profile: p)),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(const ProfileState.loading());
    final res = await _changePassword(
      currentPassword: currentPassword,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    res.fold(
      (f) => emit(ProfileState.error(message: f.message)),
      (_) => emit(const ProfileState.actionSuccess(message: 'تم تغيير كلمة المرور بنجاح!')),
    );
  }

  Future<void> logout() async {
    emit(const ProfileState.loading());
    final res = await _logout();
    res.fold(
      (_) async {
        await _logout.clearSession();
        emit(const ProfileState.loggedOut());
      },
      (_) => emit(const ProfileState.loggedOut()),
    );
  }

  void setProfile(UserProfileEntity profile) {
    emit(ProfileState.loaded(profile: profile));
  }
}

