import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class Country {
  final int id;
  final String tag;
  final String name;
  final String flag;
  final String season;

  Country(this.id, this.tag, this.name, this.flag, this.season);

  factory Country.fromJson(Map<String, dynamic> data) =>
      _$CountryFromJson(data);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
