// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Statistics _$StatisticsFromJson(Map<String, dynamic> json) => Statistics(
      (json['episodes'] as List<dynamic>)
          .map((e) => EpisodeStatistics.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['scans'] as List<dynamic>)
          .map((e) => ScanStatistics.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['animes'] as List<dynamic>)
          .map((e) => AnimeStatistics.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatisticsToJson(Statistics instance) =>
    <String, dynamic>{
      'episodes': instance.episodes.map((e) => e.toJson()).toList(),
      'scans': instance.scans.map((e) => e.toJson()).toList(),
      'animes': instance.animes.map((e) => e.toJson()).toList(),
    };
