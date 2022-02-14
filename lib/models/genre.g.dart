// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Genre _$GenreFromJson(Map<String, dynamic> json) {
  return Genre(
    json['id'] as int,
    json['name'] as String,
    json['fr'] as String,
  );
}

Map<String, dynamic> _$GenreToJson(Genre instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fr': instance.fr,
    };
