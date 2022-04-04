import 'package:json_annotation/json_annotation.dart';

part 'scan.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Scan {
  final String platform;
  final String platformUrl;
  final String platformImage;
  final int animeId;
  final String anime;
  final String animeImage;
  final int id;
  final String releaseDate;
  final int number;
  final String episodeType;
  final String langType;
  final String url;
  final int notation;

  Scan(
    this.platform,
    this.platformUrl,
    this.platformImage,
    this.animeId,
    this.anime,
    this.animeImage,
    this.id,
    this.releaseDate,
    this.number,
    this.episodeType,
    this.langType,
    this.url,
    this.notation,
  );

  factory Scan.fromJson(Map<String, dynamic> data) => _$ScanFromJson(data);

  Map<String, dynamic> toJson() => _$ScanToJson(this);
}
