import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class User {
  final String timestamp;
  final String pseudo;
  final int role;
  final String? image;
  final String? about;

  User(this.timestamp, this.pseudo, this.role, this.image, this.about);

  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
