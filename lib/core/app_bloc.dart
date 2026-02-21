import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uot_transport/core/api_service.dart';

class AppBloc extends Cubit<int> {
  final ApiService apiService;

  AppBloc(this.apiService) : super(0);

  // Example method using ApiService
  Future<void> fetchData() async {
    try {
      final response = await apiService.getRequest('/example');
      // Handle response
      emit(state + 1); // Dummy state change
    } catch (e) {
      // Handle error
    }
  }
}
