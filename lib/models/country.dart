import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(explicitToJson: true, nullable: false)
class Country {
  final int id;
  final String tag, name, flag, season;

  Country(this.id, this.tag, this.name, this.flag, this.season);

  factory Country.fromJson(Map<String, dynamic> data) =>
      _$CountryFromJson(data);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
