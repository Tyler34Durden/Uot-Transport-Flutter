import 'package:equatable/equatable.dart';

class AdvertisingEntity extends Equatable {
  const AdvertisingEntity({
    required this.id,
    required this.photo,
    required this.title,
    required this.description,
  });

  final int id;
  final String photo;
  final String title;
  final String description;

  @override
  List<Object?> get props => [id, photo, title, description];
}

