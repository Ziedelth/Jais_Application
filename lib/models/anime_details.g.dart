// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeDetails _$AnimeDetailsFromJson(Map<String, dynamic> json) => AnimeDetails(
      json['id'] as int,
      json['country_id'] as int,
      json['release_date'] as String,
      json['code'] as String,
      json['name'] as String,
      json['image'] as String,
      json['description'] as String?,
      json['country_season'] as String,
      json['genres'] as String?,
      (json['seasons'] as List<dynamic>)
          .map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['scans'] as List<dynamic>)
          .map((e) => Scan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnimeDetailsToJson(AnimeDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country_id': instance.countryId,
      'release_date': instance.releaseDate,
      'code': instance.code,
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'country_season': instance.countrySeason,
      'genres': instance.genres,
      'seasons': instance.seasons.map((e) => e.toJson()).toList(),
      'scans': instance.scans.map((e) => e.toJson()).toList(),
    };
