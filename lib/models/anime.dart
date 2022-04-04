import 'package:json_annotation/json_annotation.dart';

part 'anime.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Anime {
  final int id;
  final String name;
  final String? description;
  final String image;
  final int notation;

  Anime(this.id, this.name, this.description, this.image, this.notation);

  factory Anime.fromJson(Map<String, dynamic> data) => _$AnimeFromJson(data);

  Map<String, dynamic> toJson() => _$AnimeToJson(this);
}
