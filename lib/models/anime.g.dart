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
    (json['genres'] as List)
        .map((e) => Genre.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$AnimeToJson(Anime instance) => <String, dynamic>{
      'id': instance.id,
      'country': instance.country.toJson(),
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
    };
