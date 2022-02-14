// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Platform _$PlatformFromJson(Map<String, dynamic> json) => Platform(
      json['id'] as int,
      json['name'] as String,
      json['image'] as String,
      json['url'] as String,
      json['color'] as int,
    );

Map<String, dynamic> _$PlatformToJson(Platform instance) => <String, dynamic>{
      'id': instance.id,
      'color': instance.color,
      'name': instance.name,
      'image': instance.image,
      'url': instance.url,
    };
