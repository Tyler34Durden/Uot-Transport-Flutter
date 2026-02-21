import 'package:get_it/get_it.dart';
import 'package:uot_transport/core/api_service.dart';
import 'package:uot_transport/core/app_bloc.dart';
import 'package:uot_transport/auth_feature/model/repository/student_auth_repository.dart';
import 'package:uot_transport/home_feature/model/repository/home_repository.dart';
import 'package:uot_transport/station_feature/model/repository/stations_repository.dart';
import 'package:uot_transport/profile_feature/model/repository/profile_repository.dart';
import 'package:uot_transport/station_feature/model/repository/station_trips_repository.dart';
import 'package:uot_transport/trips_feature/model/repository/trips_repository.dart';
import 'package:uot_transport/auth_feature/model/repository/change_season_repository.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/student_auth_cubit.dart';
import 'package:uot_transport/home_feature/view_model/cubit/home_station_cubit.dart';
import 'package:uot_transport/home_feature/view_model/cubit/advertising_cubit.dart';
import 'package:uot_transport/station_feature/view_model/cubit/stations_cubit.dart';
import 'package:uot_transport/station_feature/view_model/cubit/station_trips_cubit.dart';
import 'package:uot_transport/trips_feature/view_model/cubit/trips_cubit.dart';
import 'package:uot_transport/profile_feature/view_model/cubit/profile_cubit.dart';
import 'package:uot_transport/auth_feature/view_model/cubit/change_season_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Register ApiService as a singleton
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // Register repositories as singletons with injected ApiService
  getIt.registerLazySingleton<StudentAuthRepository>(() => StudentAuthRepository(getIt<ApiService>()));
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepository(getIt<ApiService>()));
  getIt.registerLazySingleton<StationsRepository>(() => StationsRepository(getIt<ApiService>()));
  getIt.registerLazySingleton<ProfileRepository>(() => ProfileRepository(getIt<ApiService>()));
  getIt.registerLazySingleton<StationTripsRepository>(() => StationTripsRepository(getIt<ApiService>()));
  getIt.registerLazySingleton<TripsRepository>(() => TripsRepository(getIt<ApiService>()));
  getIt.registerLazySingleton<ChangeSeasonRepository>(() => ChangeSeasonRepository(getIt<ApiService>()));

  // Register BLoCs as factories (new instance each time)
  getIt.registerFactory<AppBloc>(() => AppBloc(getIt<ApiService>()));
  getIt.registerFactory<StudentAuthCubit>(() => StudentAuthCubit(getIt<StudentAuthRepository>()));
  getIt.registerFactory<HomeStationCubit>(() => HomeStationCubit(getIt<HomeRepository>()));
  getIt.registerFactory<AdvertisingsCubit>(() => AdvertisingsCubit(getIt<HomeRepository>()));
  getIt.registerFactory<StationsCubit>(() => StationsCubit(getIt<StationsRepository>()));
  getIt.registerFactory<StationTripsCubit>(() => StationTripsCubit(getIt<StationTripsRepository>()));
  getIt.registerFactory<TripsCubit>(() => TripsCubit(getIt<TripsRepository>()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt<ProfileRepository>()));
  getIt.registerFactory<ChangeSeasonCubit>(() => ChangeSeasonCubit(getIt<ChangeSeasonRepository>()));
}
