import '../../domain/entities/trip_route_entity.dart';

class TripRouteModel extends TripRouteEntity {
  const TripRouteModel({
    required super.id,
    required super.stationName,
    required super.orderNumber,
    required super.expectedTime,
  });

  factory TripRouteModel.fromJson(Map<String, dynamic> json) => TripRouteModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        stationName: (json['stationName'] ?? '').toString(),
        orderNumber: (json['OrderNumber'] as num?)?.toInt() ??
            (json['orderNumber'] as num?)?.toInt() ??
            0,
        expectedTime: (json['expectedTime'] ?? '').toString(),
      );
}

