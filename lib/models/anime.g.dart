// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Anime _$AnimeFromJson(Map<String, dynamic> json) {
  return Anime(
    json['id'] as int,
    Country.fromJson(json['country'] as Map<String, dynamic>),
    json['name'] as String,
    json['image'] as String,
    json['description'] as String,
  );
}

Map<String, dynamic> _$AnimeToJson(Anime instance) => <String, dynamic>{
      'id': instance.id,
      'country': instance.country.toJson(),
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
    };
