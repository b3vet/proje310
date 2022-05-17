import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user.dart';
import 'post_card.dart';

typedef Post2VoidFunc = void Function(Post);

class PostsTab extends StatelessWidget {
  const PostsTab({
    Key? key,
    required this.posts,
    required this.deletePost,
    required this.incrementLikes,
    required this.user,
  }) : super(key: key);
  final List<Post> posts;
  final Post2VoidFunc deletePost;
  final Post2VoidFunc incrementLikes;
  final User user;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: posts
          .map(
            (post) => PostCard(
              post: post,
              user: user,
              delete: () {
                deletePost(post);
              },
              incrementLike: () {
                incrementLikes(post);
              },
            ),
          )
          .toList(),
    );
  }
}
