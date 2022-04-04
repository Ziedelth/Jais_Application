import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Episode {
  final String platform;
  final String platformUrl;
  final String platformImage;
  final int animeId;
  final String anime;
  final int id;
  final String releaseDate;
  final int season;
  final int number;
  final String countrySeason;
  final String episodeType;
  final String langType;
  final String episodeId;
  final String? title;
  final String url;
  final String image;
  final int duration;
  final int notation;

  Episode(
    this.platform,
    this.platformUrl,
    this.platformImage,
    this.animeId,
    this.anime,
    this.id,
    this.releaseDate,
    this.season,
    this.number,
    this.countrySeason,
    this.episodeType,
    this.langType,
    this.episodeId,
    this.title,
    this.url,
    this.image,
    this.duration,
    this.notation,
  );

  factory Episode.fromJson(Map<String, dynamic> data) =>
      _$EpisodeFromJson(data);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
