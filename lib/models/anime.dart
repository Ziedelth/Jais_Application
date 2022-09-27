import 'package:jais/models/country.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/genre.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime.g.dart';

@JsonSerializable(explicitToJson: true)
class Anime {
  final int id;
  final List<String> codes;
  final List<Genre> genres;
  final Country country;
  String releaseDate;
  String name;
  String? url;
  String image;
  String? description;
  final int inWatchlist;

  @JsonKey(ignore: true)
  final List<Episode> episodes = <Episode>[];

  Anime(
    this.id,
    this.codes,
    this.genres,
    this.country,
    this.releaseDate,
    this.name,
    this.url,
    this.image,
    this.description,
    this.inWatchlist,
  );

  factory Anime.fromJson(Map<String, dynamic> data) => _$AnimeFromJson(data);

  Map<String, dynamic> toJson() => _$AnimeToJson(this);

  // Copy
  Anime copyWith({
    String? name,
    String? description,
  }) {
    return Anime(
      id,
      codes,
      genres,
      country,
      releaseDate,
      name ?? this.name,
      url,
      image,
      description ?? this.description,
      inWatchlist,
    );
  }
}
