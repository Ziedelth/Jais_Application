// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) {
  return Country(
    json['id'] as int,
    json['tag'] as String,
    json['name'] as String,
    json['flag'] as String,
    json['season'] as String,
  );
}

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'name': instance.name,
      'flag': instance.flag,
      'season': instance.season,
    };
