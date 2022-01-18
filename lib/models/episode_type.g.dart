// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeType _$EpisodeTypeFromJson(Map<String, dynamic> json) {
  return EpisodeType(
    json['id'] as int,
    json['name'] as String,
    json['fr'] as String,
  );
}

Map<String, dynamic> _$EpisodeTypeToJson(EpisodeType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fr': instance.fr,
    };
