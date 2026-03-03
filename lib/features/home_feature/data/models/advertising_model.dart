import '../../domain/entities/advertising_entity.dart';

class AdvertisingModel extends AdvertisingEntity {
  const AdvertisingModel({
    required super.id,
    required super.photo,
    required super.title,
    required super.description,
  });

  factory AdvertisingModel.fromJson(Map<String, dynamic> json) => AdvertisingModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        photo: (json['photo'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'photo': photo,
        'title': title,
        'description': description,
      };
}

