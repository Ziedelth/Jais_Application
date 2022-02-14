import 'package:json_annotation/json_annotation.dart';

part 'episode_type.g.dart';

@JsonSerializable(explicitToJson: true)
class EpisodeType {
  final int id;
  final String name, fr;

  EpisodeType(this.id, this.name, this.fr);

  factory EpisodeType.fromJson(Map<String, dynamic> data) =>
      _$EpisodeTypeFromJson(data);

  Map<String, dynamic> toJson() => _$EpisodeTypeToJson(this);
}
