import 'package:json_annotation/json_annotation.dart';

part 'simulcast.g.dart';

@JsonSerializable(explicitToJson: true)
class Simulcast {
  final int id;
  final String simulcast;

  Simulcast(this.id, this.simulcast);

  factory Simulcast.fromJson(Map<String, dynamic> data) =>
      _$SimulcastFromJson(data);

  Map<String, dynamic> toJson() => _$SimulcastToJson(this);
}
