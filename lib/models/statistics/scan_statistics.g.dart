// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanStatistics _$ScanStatisticsFromJson(Map<String, dynamic> json) =>
    ScanStatistics(
      json['scan_id'] as int,
      json['count'] as int,
    );

Map<String, dynamic> _$ScanStatisticsToJson(ScanStatistics instance) =>
    <String, dynamic>{
      'scan_id': instance.scanId,
      'count': instance.count,
    };
