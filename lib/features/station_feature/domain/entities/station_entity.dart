import 'package:equatable/equatable.dart';

class StationEntity extends Equatable {
  const StationEntity({
    required this.id,
    required this.name,
    required this.location,
  });

  final int id;
  final String name;
  final String location;


  @override
  List<Object?> get props => [id, name, location];
}