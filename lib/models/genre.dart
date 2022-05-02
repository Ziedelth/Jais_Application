import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable(explicitToJson: true)
class Genre {
  final int id;
  final String name;
  final String fr;

  Genre(this.id, this.name, this.fr);

  factory Genre.fromJson(Map<String, dynamic> data) => _$GenreFromJson(data);

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}
