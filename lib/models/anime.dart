import 'package:jais/models/country.dart';
import 'package:jais/models/genre.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime.g.dart';

@JsonSerializable(explicitToJson: true, nullable: false)
class Anime {
  final int id;
  final Country country;
  final String name, image, description;
  final List<Genre> genres;

  Anime(this.id, this.country, this.name, this.image, this.description,
      this.genres);

  factory Anime.fromJson(Map<String, dynamic> data) => _$AnimeFromJson(data);

  Map<String, dynamic> toJson() => _$AnimeToJson(this);
}
