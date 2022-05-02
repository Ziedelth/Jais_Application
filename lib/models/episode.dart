import 'package:jais/models/anime.dart';
import 'package:jais/models/episode_type.dart';
import 'package:jais/models/lang_type.dart';
import 'package:jais/models/platform.dart';
import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable(explicitToJson: true)
class Episode {
  final int id;
  final Platform platform;
  final Anime anime;
  final EpisodeType episodeType;
  final LangType langType;
  final String releaseDate;
  final int season;
  final int number;
  final String episodeId;
  final String? title;
  final String url;
  final String image;
  final int duration;

  Episode(
    this.id,
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
