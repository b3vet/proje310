import 'package:json_annotation/json_annotation.dart';
import './user.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  int id;
  String text;
  String userId; //uid of of the user
  String? imageUrl;
  String? videoUrl;

  Address? location;
  List<Topic>? topics;

  List<String> likedBy; //list of uids that liked this post
  List<String>
      comments; //list of commentids that is a comment to this post (comment are also posts!!!!)
  //initially, both likedBy and comments are emptyl lists
  Post({
    required this.id,
    required this.text,
    required this.likedBy,
    required this.comments,
    required this.userId,
    this.imageUrl,
    this.videoUrl,
    this.location,
    this.topics,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
