// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeStatistics _$EpisodeStatisticsFromJson(Map<String, dynamic> json) =>
    EpisodeStatistics(
      json['episode_id'] as int,
      json['count'] as int,
    );

Map<String, dynamic> _$EpisodeStatisticsToJson(EpisodeStatistics instance) =>
    <String, dynamic>{
      'episode_id': instance.episodeId,
      'count': instance.count,
    };
