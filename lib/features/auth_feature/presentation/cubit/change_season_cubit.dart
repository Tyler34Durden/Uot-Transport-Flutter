import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:uot_transport/features/auth_feature/domain/entities/change_season_otp_request.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_send_request.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_update_request.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/change_season_send_otp_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/change_season_update_semester_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/change_season_validate_otp_usecase.dart';

import 'change_season_state.dart';

class ChangeSeasonCubit extends Cubit<ChangeSeasonState> {
  final ChangeSeasonSendOtpUseCase sendOtpUseCase;
  final ChangeSeasonValidateOtpUseCase validateOtpUseCase;
  final ChangeSeasonUpdateSemesterUseCase updateSemesterUseCase;

  ChangeSeasonCubit({
    required this.sendOtpUseCase,
    required this.validateOtpUseCase,
    required this.updateSemesterUseCase,
  }) : super(const ChangeSeasonState.initial());

  Future<void> sendOtp(String email) async {
    emit(const ChangeSeasonState.loading());
    final result = await sendOtpUseCase(ChangeSeasonSendRequest(email: email));
    result.fold(
      (failure) => emit(ChangeSeasonState.failure(message: failure.message)),
      (_) => emit(const ChangeSeasonState.success()),
    );
  }

  Future<void> validateOtp({required String email, required String otp}) async {
    emit(const ChangeSeasonState.loading());
    final result = await validateOtpUseCase(
      ChangeSeasonOtpRequest(email: email, otp: otp),
    );
    result.fold(
      (failure) => emit(ChangeSeasonState.failure(message: failure.message)),
      (_) => emit(const ChangeSeasonState.success()),
    );
  }

  Future<void> updateSemester(ChangeSeasonUpdateRequest request) async {
    emit(const ChangeSeasonState.loading());
    final result = await updateSemesterUseCase(request);
    result.fold(
      (failure) => emit(ChangeSeasonState.failure(message: failure.message)),
      (_) => emit(const ChangeSeasonState.success()),
    );
  }
}
