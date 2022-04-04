import 'package:json_annotation/json_annotation.dart';

part 'episode_statistics.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class EpisodeStatistics {
  final int episodeId;
  final int count;

  EpisodeStatistics(this.episodeId, this.count);

  factory EpisodeStatistics.fromJson(Map<String, dynamic> data) =>
      _$EpisodeStatisticsFromJson(data);

  Map<String, dynamic> toJson() => _$EpisodeStatisticsToJson(this);
}
