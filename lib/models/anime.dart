import 'package:jais/models/country.dart';
import 'package:jais/models/episode.dart';
import 'package:jais/models/genre.dart';
import 'package:jais/models/scan.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime.g.dart';

@JsonSerializable(explicitToJson: true)
class Anime {
  final int id;
  final List<String> codes;
  final List<Genre> genres;
  final Country country;
  final String releaseDate;
  final String name;
  final String? url;
  final String image;
  final String? description;

  @JsonKey(ignore: true)
  final List<Episode> episodes = <Episode>[];
  @JsonKey(ignore: true)
  final List<Scan> scans = <Scan>[];

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
  );

  factory Anime.fromJson(Map<String, dynamic> data) => _$AnimeFromJson(data);

  Map<String, dynamic> toJson() => _$AnimeToJson(this);
}
