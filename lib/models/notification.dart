import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class AppNotification {
  String id;
  String subjectId;
  String postId;
  String type; //"share" or "like"

  AppNotification({
    required this.id,
    required this.subjectId,
    required this.type,
    required this.postId,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);
}
