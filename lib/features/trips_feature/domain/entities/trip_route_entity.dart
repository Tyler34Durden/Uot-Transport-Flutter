import 'package:equatable/equatable.dart';

class TripRouteEntity extends Equatable {
  const TripRouteEntity({
    required this.id,
    required this.stationName,
    required this.orderNumber,
    required this.expectedTime,
  });

  final int id;
  final String stationName;
  final int orderNumber;
  final String expectedTime;

  @override
  List<Object?> get props => [id, stationName, orderNumber, expectedTime];
}

