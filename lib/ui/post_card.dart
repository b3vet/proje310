import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/user_provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/dummy_data.dart';
import '../utils/route_args.dart';
import '../utils/screenSizes.dart';

typedef PostAndUserToVoid = void Function(Post, User);

class PostCard extends StatelessWidget {
  final Post post;
  final PostAndUserToVoid incrementLike;
  const PostCard({
    Key? key,
    required this.post,
    required this.incrementLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<UserProvider>(context, listen: false).user!;
    User postUser = DummyData.users.firstWhere(
      (element) => element.id == post.userId,
    );
    Duration differenceFromNow = DateTime.now().difference(post.createdAt);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/singlePostView',
          arguments: SinglePostViewArguments(
            post: post,
          ),
        );
      },
      child: Card(
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.fromLTRB(5, 3, 5, 3),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      postUser.profilePictureUrl ??
                          'https://image.winudf.com/v2/image1/Y29tLmZpcmV3aGVlbC5ibGFja3NjcmVlbl9zY3JlZW5fMF8xNTgyNjgwMjgzXzA2MQ/screen-0.jpg?fakeurl=1&type=.jpg',
                    ),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postUser.name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '@${postUser.username}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Text(
                    differenceFromNow.inSeconds > 60
                        ? differenceFromNow.inMinutes > 60
                            ? differenceFromNow.inHours > 24
                                ? '· ${differenceFromNow.inDays} d'
                                : '· ${differenceFromNow.inHours} h'
                            : '· ${differenceFromNow.inMinutes} m'
                        : '· ${differenceFromNow.inSeconds} s',
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                post.text,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              post.imageUrl != null
                  ? _postImageView(context, post)
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.black,
                        size: 20,
                      ),
                      label: Text(
                        post.commentCount.toString(),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.repeat,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      post.shareCount.toString(),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => incrementLike(post, currentUser),
                      icon: Icon(
                        post.likedBy.contains(currentUser.id)
                            ? Icons.star_rate_rounded
                            : Icons.star_outline_rounded,
                        color: Colors.yellow.shade800,
                        size: 20,
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
      ),
    );
  }

  Widget _postImageView(BuildContext context, Post post) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Image.network(
        post.imageUrl!,
        height: screenHeight(context, dividedBy: 4),
        fit: BoxFit.cover,
      ),
    );
  }
}
