import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

// Mock User class
class User {
  final int id;
  final String name;
  User(this.id, this.name);
  @override
  String toString() => 'User(id: $id, name: $name)';
}

// API Service
abstract class ApiService {
  Future<User> getUser(int id);
}

class ApiServiceImpl implements ApiService {
  @override
  Future<User> getUser(int id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    return User(id, 'DemoUser');
  }
}

// AuthState classes
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthLoaded extends AuthState {
  final User user;
  AuthLoaded(this.user);
}

// AuthRepository
abstract class AuthRepository {
  Future<User> login(String username, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  final ApiService apiService;
  AuthRepositoryImpl(this.apiService);
  @override
  Future<User> login(String username, String password) async {
    // Simulate login
    return apiService.getUser(1);
  }
}

// Bloc that depends on Repository
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  AuthCubit(this.repository) : super(AuthInitial());

  void login(String username, String password) async {
    emit(AuthLoading());
    final user = await repository.login(username, password);
    emit(AuthLoaded(user));
  }
}

// Register dependencies in GetIt
final getIt = GetIt.instance;
void setupDI() {
  getIt.registerLazySingleton<ApiService>(() => ApiServiceImpl());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<ApiService>())
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
}

void main() async {
  setupDI();
  final authCubit = getIt<AuthCubit>();
  print(authCubit.state); // Should be AuthInitial
  authCubit.login('demo', 'password');
  await Future.delayed(const Duration(milliseconds: 500));
  print(authCubit.state); // Should be AuthLoaded
}
