// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Season _$SeasonFromJson(Map<String, dynamic> json) => Season(
      json['season'] as int,
      (json['episodes'] as List<dynamic>)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SeasonToJson(Season instance) => <String, dynamic>{
      'season': instance.season,
      'episodes': instance.episodes.map((e) => e.toJson()).toList(),
    };
