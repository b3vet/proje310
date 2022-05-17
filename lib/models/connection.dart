import 'package:json_annotation/json_annotation.dart';
import './user.dart';

part 'connection.g.dart';

@JsonSerializable()
class Connection {
  String id;
  User subject;
  User target;
  String
      type; //either "connected" or "requested"; this is how we are going to manage the follower requests and following follower relations

  Connection({
    required this.id,
    required this.subject,
    required this.target,
    required this.type,
  });

  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);
  Map<String, dynamic> toJson() => _$ConnectionToJson(this);
}
