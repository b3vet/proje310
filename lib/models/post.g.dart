// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as int,
      text: json['text'] as String,
      likedBy:
          (json['likedBy'] as List<dynamic>).map((e) => e as String).toList(),
      comments:
          (json['comments'] as List<dynamic>).map((e) => e as String).toList(),
      userId: json['userId'] as String,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      location: json['location'] == null
          ? null
          : Address.fromJson(json['location'] as Map<String, dynamic>),
      topics: (json['topics'] as List<dynamic>?)
          ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'userId': instance.userId,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'location': instance.location,
      'topics': instance.topics,
      'likedBy': instance.likedBy,
      'comments': instance.comments,
    };
