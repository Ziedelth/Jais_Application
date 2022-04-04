import 'package:json_annotation/json_annotation.dart';

part 'scan_statistics.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ScanStatistics {
  final int scanId;
  final int count;

  ScanStatistics(this.scanId, this.count);

  factory ScanStatistics.fromJson(Map<String, dynamic> data) =>
      _$ScanStatisticsFromJson(data);

  Map<String, dynamic> toJson() => _$ScanStatisticsToJson(this);
}
