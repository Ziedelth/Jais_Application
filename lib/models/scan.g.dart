// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scan _$ScanFromJson(Map<String, dynamic> json) => Scan(
      json['platform'] as String,
      json['platform_url'] as String,
      json['platform_image'] as String,
      json['anime_id'] as int,
      json['anime'] as String,
      json['anime_image'] as String,
      json['id'] as int,
      json['release_date'] as String,
      json['number'] as int,
      json['episode_type'] as String,
      json['lang_type'] as String,
      json['url'] as String,
      json['notation'] as int,
    );

Map<String, dynamic> _$ScanToJson(Scan instance) => <String, dynamic>{
      'platform': instance.platform,
      'platform_url': instance.platformUrl,
      'platform_image': instance.platformImage,
      'anime_id': instance.animeId,
      'anime': instance.anime,
      'anime_image': instance.animeImage,
      'id': instance.id,
      'release_date': instance.releaseDate,
      'number': instance.number,
      'episode_type': instance.episodeType,
      'lang_type': instance.langType,
      'url': instance.url,
      'notation': instance.notation,
    };
