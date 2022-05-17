import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final User user;
  final VoidCallback delete;
  final VoidCallback incrementLike;
  const PostCard({
    Key? key,
    required this.post,
    required this.delete,
    required this.incrementLike,
    required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      margin: const EdgeInsets.fromLTRB(5, 10, 0, 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: ClipOval(
                    child: Image.network(
                      user.profilePictureUrl ??
                          'https://image.winudf.com/v2/image1/Y29tLmZpcmV3aGVlbC5ibGFja3NjcmVlbl9zY3JlZW5fMF8xNTgyNjgwMjgzXzA2MQ/screen-0.jpg?fakeurl=1&type=.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  radius: 20,
                ),
                Text(user.name),
                Text('@${user.name}'),
                Text(
                  '${post.createdAt.year.toString()}-${post.createdAt.month.toString().padLeft(2, '0')}-${post.createdAt.day.toString().padLeft(2, '0')}',
                ),
                IconButton(
                  onPressed: delete,
                  icon: const Icon(
                    Icons.delete,
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Text(
              post.text,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_comment_rounded,
                      color: Colors.black,
                    ),
                    label: Text(
                      post.commentCount.toString(),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.repeat,
                    color: Colors.black,
                  ),
                  Text(
                    post.shareCount.toString(),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: incrementLike,
                    icon: const Icon(
                      Icons.thumb_up,
                      color: Colors.red,
                    ),
                    label: Text(
                      post.likeCount.toString(),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
