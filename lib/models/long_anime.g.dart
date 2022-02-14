// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'long_anime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LongAnime _$LongAnimeFromJson(Map<String, dynamic> json) => LongAnime(
      (json['seasons'] as List<dynamic>)
          .map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['id'] as int,
      Country.fromJson(json['country'] as Map<String, dynamic>),
      json['name'] as String,
      json['image'] as String,
      json['description'] as String?,
    );

Map<String, dynamic> _$LongAnimeToJson(LongAnime instance) => <String, dynamic>{
      'seasons': instance.seasons.map((e) => e.toJson()).toList(),
      'genres': instance.genres.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'country': instance.country.toJson(),
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
    };
