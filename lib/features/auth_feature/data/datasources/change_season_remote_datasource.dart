import 'package:dio/dio.dart';

import 'package:uot_transport/core/api_service.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_send_request.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_otp_request.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_update_request.dart';

class ChangeSeasonRemoteDataSource {
  final ApiService apiService;

  const ChangeSeasonRemoteDataSource(this.apiService);

  Future<Response> sendOtp(ChangeSeasonSendRequest request) {
    return apiService.postRequest('semester/update/otp', request.toJson());
  }

  Future<Response> validateOtp(ChangeSeasonOtpRequest request) {
    return apiService.postRequest(
        'semester/update/validateOtp', request.toJson());
  }

  Future<Response> updateSemester(ChangeSeasonUpdateRequest request) {
    return apiService.postRequest('semester/update', request.toJson());
  }
}
