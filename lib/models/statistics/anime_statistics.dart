import 'package:json_annotation/json_annotation.dart';

part 'anime_statistics.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class AnimeStatistics {
  final int animeId;
  final int count;

  AnimeStatistics(this.animeId, this.count);

  factory AnimeStatistics.fromJson(Map<String, dynamic> data) =>
      _$AnimeStatisticsFromJson(data);

  Map<String, dynamic> toJson() => _$AnimeStatisticsToJson(this);
}
