import 'package:jais/models/anime.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable(explicitToJson: true)
class Member {
  final int id;
  final String pseudo;
  final String? token;
  final int role;
  final List<Anime> watchlist;

  Member(this.id, this.pseudo, this.token, this.role, this.watchlist);

  factory Member.fromJson(Map<String, dynamic> data) => _$MemberFromJson(data);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
