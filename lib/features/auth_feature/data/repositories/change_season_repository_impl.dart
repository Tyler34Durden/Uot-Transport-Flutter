import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:uot_transport/core/error/failures.dart';
import 'package:uot_transport/core/utilities.dart';
import 'package:uot_transport/features/auth_feature/data/datasources/change_season_remote_datasource.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_otp_request.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_send_request.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_update_request.dart';
import 'package:uot_transport/features/auth_feature/domain/repositories/change_season_repository.dart';

class ChangeSeasonRepositoryImpl implements ChangeSeasonRepository {
  final ChangeSeasonRemoteDataSource remote;

  const ChangeSeasonRepositoryImpl(this.remote);

  @override
  ResultVoid sendOtp(ChangeSeasonSendRequest request) async {
    try {
      await remote.sendOtp(request);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultVoid validateOtp(ChangeSeasonOtpRequest request) async {
    try {
      await remote.validateOtp(request);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  ResultVoid updateSemester(ChangeSeasonUpdateRequest request) async {
    try {
      await remote.updateSemester(request);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(dynamic e) {
    if (e is Map && e['message'] != null) {
      return ApiFailure(
        message: e['message'].toString(),
        statusCode: (e['statusCode'] as int?) ?? 500,
      );
    }
    if (e is DioException) {
      final errorData = e.response?.data;
      if (errorData is Map && errorData['message'] != null) {
        return ApiFailure(
          message: errorData['message'].toString(),
          statusCode: e.response?.statusCode ?? 500,
        );
      }
      return ApiFailure(
        message: e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
    return ApiFailure(message: e.toString(), statusCode: 500);
  }
}

