// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['timestamp'] as String,
      json['pseudo'] as String,
      json['role'] as int,
      json['image'] as String?,
      json['about'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp,
      'pseudo': instance.pseudo,
      'role': instance.role,
      'image': instance.image,
      'about': instance.about,
    };
