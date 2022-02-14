import 'package:jais/models/country.dart';
import 'package:json_annotation/json_annotation.dart';

part 'anime.g.dart';

@JsonSerializable(explicitToJson: true, nullable: false)
class Anime {
  final int id;
  final Country country;
  final String name, image;
  final String? description;

  Anime(this.id, this.country, this.name, this.image, this.description);

  factory Anime.fromJson(Map<String, dynamic> data) => _$AnimeFromJson(data);

  Map<String, dynamic> toJson() => _$AnimeToJson(this);
}
