// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Anime _$AnimeFromJson(Map<String, dynamic> json) => Anime(
      json['id'] as int,
      (json['codes'] as List<dynamic>).map((e) => e as String).toList(),
      (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e as Map<String, dynamic>))
          .toList(),
      Country.fromJson(json['country'] as Map<String, dynamic>),
      json['releaseDate'] as String,
      json['name'] as String,
      json['url'] as String?,
      json['image'] as String,
      json['description'] as String?,
      json['inWatchlist'] as int,
    );

Map<String, dynamic> _$AnimeToJson(Anime instance) => <String, dynamic>{
      'id': instance.id,
      'codes': instance.codes,
      'genres': instance.genres.map((e) => e.toJson()).toList(),
      'country': instance.country.toJson(),
      'releaseDate': instance.releaseDate,
      'name': instance.name,
      'url': instance.url,
      'image': instance.image,
      'description': instance.description,
      'inWatchlist': instance.inWatchlist,
    };
