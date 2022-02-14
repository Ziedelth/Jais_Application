import 'package:json_annotation/json_annotation.dart';

part 'platform.g.dart';

@JsonSerializable(explicitToJson: true)
class Platform {
  final int id, color;
  final String name, image, url;

  Platform(this.id, this.name, this.image, this.url, this.color);

  factory Platform.fromJson(Map<String, dynamic> data) =>
      _$PlatformFromJson(data);

  Map<String, dynamic> toJson() => _$PlatformToJson(this);
}
