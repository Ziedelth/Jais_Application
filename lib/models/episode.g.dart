// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
      json['platform'] as String,
      json['platform_url'] as String,
      json['platform_image'] as String,
      json['anime_id'] as int,
      json['anime'] as String,
      json['id'] as int,
      json['release_date'] as String,
      json['season'] as int,
      json['number'] as int,
      json['country_season'] as String,
      json['episode_type'] as String,
      json['lang_type'] as String,
      json['episode_id'] as String,
      json['title'] as String?,
      json['url'] as String,
      json['image'] as String,
      json['duration'] as int,
      json['notation'] as int,
    );

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'platform': instance.platform,
      'platform_url': instance.platformUrl,
      'platform_image': instance.platformImage,
      'anime_id': instance.animeId,
      'anime': instance.anime,
      'id': instance.id,
      'release_date': instance.releaseDate,
      'season': instance.season,
      'number': instance.number,
      'country_season': instance.countrySeason,
      'episode_type': instance.episodeType,
      'lang_type': instance.langType,
      'episode_id': instance.episodeId,
      'title': instance.title,
      'url': instance.url,
      'image': instance.image,
      'duration': instance.duration,
      'notation': instance.notation,
    };
