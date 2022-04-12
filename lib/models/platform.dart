import 'package:json_annotation/json_annotation.dart';

part 'platform.g.dart';

@JsonSerializable(explicitToJson: true)
class Platform {
  final int id;
  final String name;
  final String url;
  final String image;
  final int color;

  Platform(this.id, this.name, this.url, this.image, this.color);

  factory Platform.fromJson(Map<String, dynamic> data) =>
      _$PlatformFromJson(data);

  Map<String, dynamic> toJson() => _$PlatformToJson(this);
}
