import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user.dart';
import 'post_card.dart';

typedef PostAndUserToVoid = void Function(Post, AppUser);

class PostsTab extends StatelessWidget {
  const PostsTab({
    Key? key,
    required this.posts,
    required this.incrementLikes,
  }) : super(key: key);
  final List<Post> posts;
  final PostAndUserToVoid incrementLikes;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: posts
          .map(
            (post) => PostCard(
              post: post,
              incrementLike: incrementLikes,
            ),
          )
          .toList(),
    );
  }
}
