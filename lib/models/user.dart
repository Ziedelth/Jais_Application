import 'package:jais/models/statistics.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class User {
  final int id;
  final String timestamp;
  final String pseudo;
  final int role;
  final String? image;
  final String? about;
  Statistics? statistics;

  User(
    this.id,
    this.timestamp,
    this.pseudo,
    this.role,
    this.image,
    this.about, {
    this.statistics,
  });

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
