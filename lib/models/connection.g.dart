// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) => Connection(
      id: json['id'] as String,
      subject: AppUser.fromJson(json['subject'] as Map<String, dynamic>),
      target: AppUser.fromJson(json['target'] as Map<String, dynamic>),
      type: json['type'] as String,
    );

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'target': instance.target,
      'type': instance.type,
    };
