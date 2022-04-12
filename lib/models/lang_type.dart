import 'package:json_annotation/json_annotation.dart';

part 'lang_type.g.dart';

@JsonSerializable(explicitToJson: true)
class LangType {
  final int id;
  final String name;
  final String fr;

  LangType(this.id, this.name, this.fr);

  factory LangType.fromJson(Map<String, dynamic> data) =>
      _$LangTypeFromJson(data);

  Map<String, dynamic> toJson() => _$LangTypeToJson(this);
}
