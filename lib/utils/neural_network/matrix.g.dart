// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matrix.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Matrix _$MatrixFromJson(Map<String, dynamic> json) => Matrix(
      json['rows'] as int,
      json['cols'] as int,
    )..matrix = (json['matrix'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as num).toList())
        .toList();

Map<String, dynamic> _$MatrixToJson(Matrix instance) => <String, dynamic>{
      'rows': instance.rows,
      'cols': instance.cols,
      'matrix': instance.matrix,
    };
