import 'package:jais/models/anime.dart';
import 'package:jais/models/episode_type.dart';
import 'package:jais/models/lang_type.dart';
import 'package:jais/models/platform.dart';
import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable(explicitToJson: true, nullable: false)
class Episode {
  final Platform platform;
  final Anime anime;
  final EpisodeType episodeType;
  final LangType langType;
  final String releaseDate, episodeId, url, image;
  final int season, number, duration;
  final String? title;

  Episode(
    this.platform,
    this.anime,
    this.episodeType,
    this.langType,
    this.releaseDate,
    this.season,
    this.number,
    this.episodeId,
    this.title,
    this.url,
    this.image,
    this.duration,
  );

  factory Episode.fromJson(Map<String, dynamic> data) =>
      _$EpisodeFromJson(data);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
