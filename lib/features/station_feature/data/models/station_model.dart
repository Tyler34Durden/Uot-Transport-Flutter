import 'dart:convert';

import 'package:uot_transport/core/utilities.dart';
import '../../domain/entities/station_entity.dart';

class StationModel extends StationEntity {
  const StationModel({
    required super.id,
    required super.name,
    required super.location,
  });


factory StationModel.fromJson(String source) =>
    StationModel.fromMap(jsonDecode(source) as DataMap);

   StationModel.fromMap(DataMap map)
      : this(
          id: _readId(map['id']),
          name: (map['name'] ?? '').toString(),
          location: _readLocation(map['location']),
        );

  static int _readId(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _readLocation(Object? value) {
    if (value == null) return '';
    // Handles API values like [32.851972, 13.220949]
    if (value is List && value.length >= 2) {
      return '${value[0]}, ${value[1]}';
    }
    return value.toString();
  }

   StationModel copyWith({
    int? id,
    String? name,
    String? location,
}){
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
    );
   }


   DataMap toMap() => {
      'id': id,
      'name': name,
      'location': location,
   };

   String toJson() => jsonEncode(toMap());

}