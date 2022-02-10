// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Scan _$ScanFromJson(Map<String, dynamic> json) {
  return Scan(
    Platform.fromJson(json['platform'] as Map<String, dynamic>),
    Anime.fromJson(json['anime'] as Map<String, dynamic>),
    EpisodeType.fromJson(json['episodeType'] as Map<String, dynamic>),
    LangType.fromJson(json['langType'] as Map<String, dynamic>),
    json['releaseDate'] as String,
    json['number'] as int,
    json['url'] as String,
  );
}

Map<String, dynamic> _$ScanToJson(Scan instance) => <String, dynamic>{
      'platform': instance.platform.toJson(),
      'anime': instance.anime.toJson(),
      'episodeType': instance.episodeType.toJson(),
      'langType': instance.langType.toJson(),
      'releaseDate': instance.releaseDate,
      'url': instance.url,
      'number': instance.number,
    };
