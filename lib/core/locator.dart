import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uot_transport/core/api_service.dart';
import 'package:uot_transport/features/notifications_feature/data/datasources/notifications_remote_datasource.dart';
import 'package:uot_transport/features/notifications_feature/data/repositories/notifications_repository_impl.dart';
import 'package:uot_transport/features/notifications_feature/domain/repositories/notifications_repository.dart';
import 'package:uot_transport/features/notifications_feature/domain/usecases/get_notifications_usecase.dart';
import 'package:uot_transport/features/notifications_feature/domain/usecases/mark_all_notifications_read_usecase.dart';
import 'package:uot_transport/features/notifications_feature/domain/usecases/mark_notification_read_usecase.dart';
import 'package:uot_transport/features/notifications_feature/presentation/cubit/notifications_cubit.dart';
import 'package:uot_transport/features/auth_feature/data/datasources/auth_remote_datasource.dart';
import 'package:uot_transport/features/auth_feature/data/datasources/change_season_remote_datasource.dart';
import 'package:uot_transport/features/auth_feature/data/repositories/auth_repository_impl.dart';
import 'package:uot_transport/features/auth_feature/data/repositories/change_season_repository_impl.dart';
import 'package:uot_transport/features/auth_feature/domain/repositories/auth_repository.dart';
import 'package:uot_transport/features/auth_feature/domain/repositories/change_season_repository.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/forgot_password_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/login_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/register_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/reset_password_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/validate_otp_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/verify_otp_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/change_season_send_otp_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/change_season_update_semester_usecase.dart';
import 'package:uot_transport/features/auth_feature/domain/usecases/change_season_validate_otp_usecase.dart';
import 'package:uot_transport/features/auth_feature/presentation/cubit/auth_cubit.dart';
import 'package:uot_transport/features/auth_feature/presentation/cubit/change_season_cubit.dart';
import 'package:uot_transport/features/station_feature/data/datasources/station_remote_datasource.dart';
import 'package:uot_transport/features/station_feature/data/datasources/station_remote_datasource_impl.dart';
import 'package:uot_transport/features/station_feature/data/datasources/station_trips_remote_datasource.dart';
import 'package:uot_transport/features/station_feature/data/datasources/station_trips_remote_datasource_impl.dart'
    as clean_station_trips_ds;
import 'package:uot_transport/features/station_feature/data/repositories/station_repository_impl.dart';
import 'package:uot_transport/features/station_feature/data/repositories/station_trips_repository_impl.dart'
    as clean_station_trips_repo;
import 'package:uot_transport/features/station_feature/domain/repositories/station_repositories.dart';
import 'package:uot_transport/features/station_feature/domain/repositories/station_trips_repository.dart';
import 'package:uot_transport/features/station_feature/domain/usecases/get_station_trips_usecase.dart';
import 'package:uot_transport/features/station_feature/domain/usecases/get_stations_usecase.dart';
import 'package:uot_transport/features/station_feature/domain/usecases/get_searched_stations_usecase.dart';
import 'package:uot_transport/features/station_feature/presentation/cubit/station_trips_cubit.dart'
    as clean_station_trips_cubit;
import 'package:uot_transport/features/station_feature/presentation/cubit/stations_cubit.dart' as clean_station;
import 'package:uot_transport/features/trips_feature/data/datasources/trips_remote_datasource.dart';
import 'package:uot_transport/features/trips_feature/data/repositories/trips_repository_impl.dart' as clean_trips_repo;
import 'package:uot_transport/features/trips_feature/domain/repositories/trips_repository.dart' as clean_trips_domain;
import 'package:uot_transport/features/trips_feature/domain/usecases/cancel_ticket_usecase.dart';
import 'package:uot_transport/features/trips_feature/domain/usecases/create_ticket_usecase.dart';
import 'package:uot_transport/features/trips_feature/domain/usecases/get_trip_details_usecase.dart';
import 'package:uot_transport/features/trips_feature/domain/usecases/get_trip_routes_usecase.dart';
import 'package:uot_transport/features/trips_feature/domain/usecases/get_trips_by_stations_usecase.dart';
import 'package:uot_transport/features/trips_feature/domain/usecases/update_ticket_state_usecase.dart';
import 'package:uot_transport/features/trips_feature/presentation/cubit/trips_cubit.dart' as clean_trips_cubit;
import 'package:uot_transport/features/home_feature/data/datasources/home_remote_datasource.dart';
import 'package:uot_transport/features/home_feature/data/repositories/home_repository_impl.dart' as clean_home_repo;
import 'package:uot_transport/features/home_feature/domain/repositories/home_repository.dart' as clean_home_domain;
import 'package:uot_transport/features/home_feature/domain/usecases/get_advertisings_usecase.dart';
import 'package:uot_transport/features/home_feature/domain/usecases/get_home_stations_usecase.dart';
import 'package:uot_transport/features/home_feature/domain/usecases/get_my_trips_usecase.dart';
import 'package:uot_transport/features/home_feature/domain/usecases/get_today_trips_usecase.dart';
import 'package:uot_transport/features/home_feature/presentation/cubit/home_cubit.dart' as clean_home_cubit;
import 'package:uot_transport/features/profile_feature/data/datasources/profile_local_datasource.dart';
import 'package:uot_transport/features/profile_feature/data/datasources/profile_remote_datasource.dart';
import 'package:uot_transport/features/profile_feature/data/repositories/profile_repository_impl.dart';
import 'package:uot_transport/features/profile_feature/domain/repositories/profile_repository.dart'
    as clean_profile_domain;
import 'package:uot_transport/features/profile_feature/domain/usecases/change_password_usecase.dart';
import 'package:uot_transport/features/profile_feature/domain/usecases/logout_usecase.dart';
import 'package:uot_transport/features/profile_feature/domain/usecases/update_phone_usecase.dart';
import 'package:uot_transport/features/profile_feature/presentation/cubit/profile_cubit.dart';



final GetIt getIt = GetIt.instance;

void setupLocator({required SharedPreferences prefs}) {
  // Core services
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  // ----------------------------
  // Clean-architecture Notifications DI
  // ----------------------------
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(getIt<NotificationsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton<MarkNotificationReadUseCase>(
    () => MarkNotificationReadUseCase(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton<MarkAllNotificationsReadUseCase>(
    () => MarkAllNotificationsReadUseCase(getIt<NotificationsRepository>()),
  );

  getIt.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(
      getNotifications: getIt<GetNotificationsUseCase>(),
      markNotificationRead: getIt<MarkNotificationReadUseCase>(),
      markAllNotificationsRead: getIt<MarkAllNotificationsReadUseCase>(),
    ),
  );

  // ----------------------------
  // Clean-architecture Auth DI
  // ----------------------------
  getIt.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasource(getIt<ApiService>()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<AuthRemoteDatasource>()));

  getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<ValidateOtpUseCase>(() => ValidateOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton<ResetPasswordUseCase>(() => ResetPasswordUseCase(getIt<AuthRepository>()));

  getIt.registerFactory<AuthCubit>(() => AuthCubit(
        loginUseCase: getIt<LoginUseCase>(),
        registerUseCase: getIt<RegisterUseCase>(),
        verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
        forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
        validateOtpUseCase: getIt<ValidateOtpUseCase>(),
        resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      ));

  // ----------------------------
  // Clean-architecture Change Season (semester update) DI
  // ----------------------------
  getIt.registerLazySingleton<ChangeSeasonRemoteDataSource>(
    () => ChangeSeasonRemoteDataSource(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ChangeSeasonRepository>(
    () => ChangeSeasonRepositoryImpl(getIt<ChangeSeasonRemoteDataSource>()),
  );
  getIt.registerLazySingleton<ChangeSeasonSendOtpUseCase>(
    () => ChangeSeasonSendOtpUseCase(getIt<ChangeSeasonRepository>()),
  );
  getIt.registerLazySingleton<ChangeSeasonValidateOtpUseCase>(
    () => ChangeSeasonValidateOtpUseCase(getIt<ChangeSeasonRepository>()),
  );
  getIt.registerLazySingleton<ChangeSeasonUpdateSemesterUseCase>(
    () => ChangeSeasonUpdateSemesterUseCase(getIt<ChangeSeasonRepository>()),
  );
  getIt.registerFactory<ChangeSeasonCubit>(
    () => ChangeSeasonCubit(
      sendOtpUseCase: getIt<ChangeSeasonSendOtpUseCase>(),
      validateOtpUseCase: getIt<ChangeSeasonValidateOtpUseCase>(),
      updateSemesterUseCase: getIt<ChangeSeasonUpdateSemesterUseCase>(),
    ),
  );

  // ----------------------------
  // Clean-architecture Station DI
  // ----------------------------
  getIt.registerLazySingleton<StationRemoteDataSource>(
    () => StationRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<StationRepository>(
    () => StationRepositoryImpl(getIt<StationRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetStationsUseCase>(
    () => GetStationsUseCase(getIt<StationRepository>()),
  );
  getIt.registerLazySingleton<GetSearchedStationsUseCase>(
    () => GetSearchedStationsUseCase(getIt<StationRepository>()),
  );

  getIt.registerFactory<clean_station.StationsCubit>(
    () => clean_station.StationsCubit(
      getStationsUseCase: getIt<GetStationsUseCase>(),
      getSearchedStationsUseCase: getIt<GetSearchedStationsUseCase>(),
    ),
  );

  // Station Trips
  getIt.registerLazySingleton<StationTripsRemoteDataSource>(
    () => clean_station_trips_ds.StationTripsRemoteDataSourceImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<StationTripsRepository>(
    () => clean_station_trips_repo.StationTripsRepositoryImpl(getIt<StationTripsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetStationTripsUseCase>(
    () => GetStationTripsUseCase(getIt<StationTripsRepository>()),
  );
  getIt.registerFactory<clean_station_trips_cubit.StationTripsCubit>(
    () => clean_station_trips_cubit.StationTripsCubit(getStationTripsUseCase: getIt<GetStationTripsUseCase>()),
  );

  // ----------------------------
  // Clean-architecture Trips DI
  // ----------------------------
  getIt.registerLazySingleton<TripsRemoteDataSource>(
    () => TripsRemoteDataSource(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<clean_trips_domain.TripsRepository>(
    () => clean_trips_repo.TripsRepositoryImpl(getIt<TripsRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetTripsByStationsUseCase>(
    () => GetTripsByStationsUseCase(getIt<clean_trips_domain.TripsRepository>()),
  );
  getIt.registerLazySingleton<GetTripRoutesUseCase>(
    () => GetTripRoutesUseCase(getIt<clean_trips_domain.TripsRepository>()),
  );
  getIt.registerLazySingleton<CreateTicketUseCase>(
    () => CreateTicketUseCase(getIt<clean_trips_domain.TripsRepository>()),
  );
  getIt.registerLazySingleton<CancelTicketUseCase>(
    () => CancelTicketUseCase(getIt<clean_trips_domain.TripsRepository>()),
  );
  getIt.registerLazySingleton<UpdateTicketStateUseCase>(
    () => UpdateTicketStateUseCase(getIt<clean_trips_domain.TripsRepository>()),
  );
  getIt.registerLazySingleton<GetTripDetailsUseCase>(
    () => GetTripDetailsUseCase(getIt<clean_trips_domain.TripsRepository>()),
  );

  getIt.registerFactory<clean_trips_cubit.TripsCubit>(
    () => clean_trips_cubit.TripsCubit(
      getTripsByStations: getIt<GetTripsByStationsUseCase>(),
      getTripRoutes: getIt<GetTripRoutesUseCase>(),
      getTripDetails: getIt<GetTripDetailsUseCase>(),
      createTicket: getIt<CreateTicketUseCase>(),
      cancelTicket: getIt<CancelTicketUseCase>(),
      updateTicketState: getIt<UpdateTicketStateUseCase>(),
    ),
  );

  // ----------------------------
  // Clean-architecture Home DI
  // ----------------------------
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSource(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<clean_home_domain.HomeRepository>(
    () => clean_home_repo.HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetAdvertisingsUseCase>(
    () => GetAdvertisingsUseCase(getIt<clean_home_domain.HomeRepository>()),
  );
  getIt.registerLazySingleton<GetHomeStationsUseCase>(
    () => GetHomeStationsUseCase(getIt<clean_home_domain.HomeRepository>()),
  );
  getIt.registerLazySingleton<GetMyTripsUseCase>(
    () => GetMyTripsUseCase(getIt<clean_home_domain.HomeRepository>()),
  );
  getIt.registerLazySingleton<GetTodayTripsUseCase>(
    () => GetTodayTripsUseCase(getIt<clean_home_domain.HomeRepository>()),
  );

  getIt.registerFactory<clean_home_cubit.HomeCubit>(
    () => clean_home_cubit.HomeCubit(
      getAdvertisings: getIt<GetAdvertisingsUseCase>(),
      getStations: getIt<GetHomeStationsUseCase>(),
      getMyTrips: getIt<GetMyTripsUseCase>(),
      getTodayTrips: getIt<GetTodayTripsUseCase>(),
    ),
  );

  // ----------------------------
  // Clean-architecture Profile DI
  // ----------------------------
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSource(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<clean_profile_domain.ProfileRepository>(
    () => ProfileRepositoryImpl(
      remote: getIt<ProfileRemoteDataSource>(),
      local: getIt<ProfileLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<UpdatePhoneUseCase>(
    () => UpdatePhoneUseCase(getIt<clean_profile_domain.ProfileRepository>()),
  );
  getIt.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(getIt<clean_profile_domain.ProfileRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<clean_profile_domain.ProfileRepository>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      repository: getIt<clean_profile_domain.ProfileRepository>(),
      updatePhone: getIt<UpdatePhoneUseCase>(),
      changePassword: getIt<ChangePasswordUseCase>(),
      logout: getIt<LogoutUseCase>(),
    ),
  );
}
