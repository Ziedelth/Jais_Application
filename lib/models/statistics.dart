import 'package:jais/models/statistics/anime_statistics.dart';
import 'package:jais/models/statistics/episode_statistics.dart';
import 'package:jais/models/statistics/scan_statistics.dart';
import 'package:json_annotation/json_annotation.dart';

part 'statistics.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Statistics {
  final List<EpisodeStatistics> episodes;
  final List<ScanStatistics> scans;
  final List<AnimeStatistics> animes;

  Statistics(this.episodes, this.scans, this.animes);

  factory Statistics.fromJson(Map<String, dynamic> data) =>
      _$StatisticsFromJson(data);

  Map<String, dynamic> toJson() => _$StatisticsToJson(this);
}
