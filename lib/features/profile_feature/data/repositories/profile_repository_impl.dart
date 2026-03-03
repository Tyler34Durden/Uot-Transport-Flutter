import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uot_transport/core/error/failures.dart';

import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource remote,
    required ProfileLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final ProfileRemoteDataSource _remote;
  final ProfileLocalDataSource _local;

  @override
  ResultFuture<String?> getToken() async {
    return Right(_local.getToken());
  }

  @override
  ResultFuture<UserProfileEntity?> getCachedUserProfile() async {
    final cached = _local.getCachedProfile();
    return Right(cached?.toEntity());
  }

  String _tokenOrFail() {
    final token = _local.getToken();
    if (token == null || token.isEmpty) {
      throw const ApiFailure(message: 'غير موثق. تحتاج إلى تسجيل الدخول.', statusCode: 401);
    }
    return token;
  }

  int _userIdOrFail() {
    final userId = _local.getUserId();
    if (userId == null || userId == 0) {
      throw const ApiFailure(message: 'تعذر العثور على معرف المستخدم.', statusCode: 400);
    }
    return userId;
  }

  Failure _mapError(dynamic e) {
    if (e is Failure) return e;
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return ApiFailure(
          message: data['message'].toString(),
          statusCode: e.response?.statusCode ?? 500,
        );
      }
      return ApiFailure(message: e.message ?? 'Unknown error', statusCode: e.response?.statusCode ?? 500);
    }
    return ApiFailure(message: e.toString(), statusCode: 500);
  }

  @override
  ResultFuture<UserProfileEntity> fetchUserProfile({required int userId}) async {
    try {
      final token = _tokenOrFail();
      final res = await _remote.fetchUserProfile(token: token, userId: userId);
      final data = res.data;
      if (data is! Map<String, dynamic>) {
        return const Left(ApiFailure(message: 'Invalid response format', statusCode: 500));
      }

      // Expect either {user: {...}} or {...}
      final userJsonDynamic = data['user'] ?? data;
      if (userJsonDynamic is! Map<String, dynamic>) {
        return const Left(ApiFailure(message: 'Invalid user payload', statusCode: 500));
      }

      final model = UserProfileModel.fromJson(userJsonDynamic);
      await _local.cacheProfile(model);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  ResultFuture<UserProfileEntity> updateUserPhone({required String phone}) async {
    try {
      final token = _tokenOrFail();
      final cached = _local.getCachedProfile();
      if (cached == null) {
        return const Left(ApiFailure(message: 'بيانات المستخدم غير موجودة.', statusCode: 400));
      }

      final payload = {
        'fullName': cached.fullName,
        'email': cached.email,
        'userZone': cached.userZone,
        'role': cached.role,
        'phone': phone,
      };

      final res = await _remote.updateUser(token: token, payload: payload);
      final data = res.data;
      if (data is! Map<String, dynamic>) {
        return const Left(ApiFailure(message: 'Invalid response format', statusCode: 500));
      }
      final userJsonDynamic = data['user'];
      if (userJsonDynamic is! Map<String, dynamic>) {
        return const Left(ApiFailure(message: 'Response data is invalid', statusCode: 500));
      }
      final model = UserProfileModel.fromJson(userJsonDynamic);
      await _local.cacheProfile(model);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  ResultVoid changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final token = _tokenOrFail();
      final payload = {
        'currentPassword': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };
      final res = await _remote.updateUser(token: token, payload: payload);
      final data = res.data;
      if (data is Map && data['message'] != null) {
        return const Right(null);
      }
      return const Right(null);
    } catch (e) {
      return Left(_mapError(e));
    }
  }

  @override
  ResultVoid logout() async {
    final token = _local.getToken();
    try {
      if (token != null && token.isNotEmpty) {
        await _remote.logout(token: token);
      }
    } catch (e) {
      // best-effort: ignore remote failures
    }

    await _local.clearSession();
    return const Right(null);
  }

  @override
  ResultVoid clearSession() async {
    await _local.clearSession();
    return const Right(null);
  }
}

