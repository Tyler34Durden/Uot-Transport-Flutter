import 'package:dio/dio.dart';

import 'package:uot_transport/core/api_service.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._api);

  final ApiService _api;

  Future<Response<dynamic>> fetchUserProfile({required String token, required int userId}) {
    return _api.getRequest('student/profile/$userId', token: token);
  }

  Future<Response<dynamic>> updateUser({required String token, required Map<String, dynamic> payload}) {
    return _api.putRequest('user', payload, token: token);
  }

  Future<Response<dynamic>> logout({required String token}) {
    return _api.postRequest('user/logout', {}, token: token);
  }
}

