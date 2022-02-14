import 'package:jais/models/episode.dart';
import 'package:json_annotation/json_annotation.dart';

part 'season.g.dart';

@JsonSerializable(explicitToJson: true)
class Season {
  final int season;
  final List<Episode> episodes;

  Season(this.season, this.episodes);

  factory Season.fromJson(Map<String, dynamic> data) => _$SeasonFromJson(data);

  Map<String, dynamic> toJson() => _$SeasonToJson(this);
}
