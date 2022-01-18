// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Episode _$EpisodeFromJson(Map<String, dynamic> json) {
  return Episode(
    Platform.fromJson(json['platform'] as Map<String, dynamic>),
    Anime.fromJson(json['anime'] as Map<String, dynamic>),
    EpisodeType.fromJson(json['episodeType'] as Map<String, dynamic>),
    LangType.fromJson(json['langType'] as Map<String, dynamic>),
    json['releaseDate'] as String,
    json['season'] as int,
    json['number'] as int,
    json['episodeId'] as String,
    json['title'] as String,
    json['url'] as String,
    json['image'] as String,
    json['duration'] as int,
  );
}

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'platform': instance.platform.toJson(),
      'anime': instance.anime.toJson(),
      'episodeType': instance.episodeType.toJson(),
      'langType': instance.langType.toJson(),
      'releaseDate': instance.releaseDate,
      'episodeId': instance.episodeId,
      'url': instance.url,
      'image': instance.image,
      'season': instance.season,
      'number': instance.number,
      'duration': instance.duration,
      'title': instance.title,
    };
