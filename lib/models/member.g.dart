// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
      json['id'] as int,
      json['pseudo'] as String,
      json['token'] as String?,
      json['role'] as int,
      (json['watchlist'] as List<dynamic>)
          .map((e) => Anime.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'id': instance.id,
      'pseudo': instance.pseudo,
      'token': instance.token,
      'role': instance.role,
      'watchlist': instance.watchlist.map((e) => e.toJson()).toList(),
    };
