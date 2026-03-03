import 'package:uot_transport/core/utilities.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_send_request.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_otp_request.dart';
import 'package:uot_transport/features/auth_feature/domain/entities/change_season_update_request.dart';

abstract class ChangeSeasonRepository {
  ResultVoid sendOtp(ChangeSeasonSendRequest request);
  ResultVoid validateOtp(ChangeSeasonOtpRequest request);
  ResultVoid updateSemester(ChangeSeasonUpdateRequest request);
}
