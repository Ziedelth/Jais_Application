import 'package:jais/models/country.dart';
import 'package:jais/models/scan.dart';
import 'package:jais/models/season.dart';
import 'package:json_annotation/json_annotation.dart';

part 'long_anime.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class LongAnime {
  final int id;
  final int countryId;
  final String releaseDate;
  final String code;
  final String name;
  final String image;
  final String? description;
  final String countrySeason;
  final String genres;
  final List<Season> seasons;
  final List<Scan> scans;

  LongAnime(
      this.id,
      this.countryId,
      this.releaseDate,
      this.code,
      this.name,
      this.image,
      this.description,
      this.countrySeason,
      this.genres,
      this.seasons,
      this.scans);

  factory LongAnime.fromJson(Map<String, dynamic> data) =>
      _$LongAnimeFromJson(data);

  Map<String, dynamic> toJson() => _$LongAnimeToJson(this);
}
