import 'package:jais/models/country.dart';
import 'package:jais/models/genre.dart';
import 'package:jais/models/season.dart';
import 'package:json_annotation/json_annotation.dart';

part 'long_anime.g.dart';

@JsonSerializable(explicitToJson: true)
class LongAnime {
  final List<Season> seasons;
  final List<Genre> genres;
  final int id;
  final Country country;
  final String name, image;
  final String? description;

  LongAnime(this.seasons, this.genres, this.id, this.country, this.name,
      this.image, this.description);

  factory LongAnime.fromJson(Map<String, dynamic> data) =>
      _$LongAnimeFromJson(data);

  Map<String, dynamic> toJson() => _$LongAnimeToJson(this);
}
