import 'package:jais/models/anime.dart';
import 'package:jais/models/episode_type.dart';
import 'package:jais/models/lang_type.dart';
import 'package:jais/models/platform.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scan.g.dart';

@JsonSerializable(explicitToJson: true)
class Scan {
  final int id;
  Platform platform;
  final Anime anime;
  EpisodeType episodeType;
  LangType langType;
  String releaseDate;
  int number;
  String url;

  Scan(
    this.id,
    this.platform,
    this.anime,
    this.episodeType,
    this.langType,
    this.releaseDate,
    this.number,
    this.url,
  );

  factory Scan.fromJson(Map<String, dynamic> data) => _$ScanFromJson(data);

  Map<String, dynamic> toJson() => _$ScanToJson(this);
}
