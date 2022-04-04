// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnimeStatistics _$AnimeStatisticsFromJson(Map<String, dynamic> json) =>
    AnimeStatistics(
      json['anime_id'] as int,
      json['count'] as int,
    );

Map<String, dynamic> _$AnimeStatisticsToJson(AnimeStatistics instance) =>
    <String, dynamic>{
      'anime_id': instance.animeId,
      'count': instance.count,
    };
