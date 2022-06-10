import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/user_provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/analytics.dart';
import '../services/db.dart';
import '../utils/route_args.dart';
import '../utils/screenSizes.dart';

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

Widget commentCard(BuildContext context, Post comment, Post commentTo) {
  DB db = DB();
  Future<dynamic> usersOfComment() async {
    return {
      'userOfComment': (await db.getUser(comment.userId))!,
      'commentedPostsOwner': (await db.getUser(commentTo.userId))!,
    };
  }

  final AppUser currentUser = Provider.of<UserProvider>(context).user!;
  Duration differenceFromNow = DateTime.now().difference(comment.createdAt);
  return FutureBuilder(
    future: usersOfComment(),
    builder: (BuildContext context, AsyncSnapshot snap) {
      if (snap.hasError) {
        return const Center(
          child: Text('An error occured while loading the comment!'),
        );
      }
      if (snap.hasData) {
        AppUser commentedPostsOwner = snap.data['commentedPostsOwner'];
        AppUser userOfComment = snap.data['userOfComment'];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/singlePostView',
              arguments: SinglePostViewArguments(
                post: comment,
              ),
            );
          },
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/standaloneProfileView',
                        arguments: StandaloneProfileViewArguments(
                          user: userOfComment,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          userOfComment.profilePictureUrl ?? 'empty',
                        ),
                        radius: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/standaloneProfileView',
                                arguments: StandaloneProfileViewArguments(
                                  user: userOfComment,
                                ),
                              );
                            },
                            child: Text(
                              userOfComment.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '@' + userOfComment.username,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const SizedBox(width: 4),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Replying to'),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/standaloneProfileView',
                                arguments: StandaloneProfileViewArguments(
                                  user: commentedPostsOwner,
                                ),
                              );
                            },
                            child: Text(
                              '@' + commentedPostsOwner.username,
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      comment.text,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              if (comment.imageUrl != null) _postImageView(context, comment),
              Padding(
                padding: const EdgeInsets.all(4.0),
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
                        comment.commentCount.toString(),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.repeat,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      comment.shareCount.toString(),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => {},
                      icon: Icon(
                        comment.likedBy.contains(currentUser.id)
                            ? Icons.star_rate_rounded
                            : Icons.star_outline_rounded,
                        color: Colors.yellow.shade800,
                        size: 20,
                      ),
                      label: Text(
                        comment.likeCount.toString(),
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
              const Divider(
                thickness: 2,
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    },
  );
}

class SinglePostView extends StatelessWidget {
  const SinglePostView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AppAnalytics.setCurrentName('Single Post Screen');
    final Post post =
        (ModalRoute.of(context)!.settings.arguments as SinglePostViewArguments)
            .post;
    DB db = DB();
    Future<dynamic> futures() async {
      return {
        'postsUser': (await db.getUser(post.userId))!,
        'postComments': (await db.getComments(post)),
      };
    }

    final AppUser currentUser =
        Provider.of<UserProvider>(context, listen: false).user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post',
        ),
      ),
      body: FutureBuilder(
        future: futures(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occured while loading post!'),
            );
          }
          if (snapshot.hasData) {
            AppUser postsUser = snapshot.data['postsUser'];
            List<Post> postComments = snapshot.data['postComments'];
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/standaloneProfileView',
                          arguments: StandaloneProfileViewArguments(
                            user: postsUser,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                postsUser.profilePictureUrl ?? 'empty',
                              ),
                              radius: 25,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                postsUser.name,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              Text('@' + postsUser.username),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        post.text,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 20,
                            ),
                      ),
                    ),
                    post.imageUrl != null
                        ? Container(
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
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '${post.createdAt.hour.toString().padLeft(2, '0')}:${post.createdAt.minute.toString().padLeft(2, '0')} · ${post.createdAt.day.toString().padLeft(2, '0')}.${post.createdAt.month.toString().padLeft(2, '0')}.${post.createdAt.year.toString()}',
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Row(
                      children: [
                        Text(
                          post.shareCount.toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(width: 2),
                        const Text('shares'),
                        const SizedBox(width: 4),
                        Text(
                          post.likeCount.toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        const SizedBox(width: 2),
                        const Text('likes'),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                          ),
                          const Icon(
                            Icons.repeat_outlined,
                          ),
                          post.likedBy.contains(currentUser.id)
                              ? IconButton(
                                  icon: Icon(
                                    Icons.star_rate_rounded,
                                    color: Colors.yellow.shade800,
                                  ),
                                  onPressed: () {},
                                )
                              : IconButton(
                                  icon: const Icon(Icons.star_outline_rounded),
                                  onPressed: () {},
                                ),
                          const Icon(
                            Icons.share_outlined,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    ...(postComments
                        .map(
                          (comment) => commentCard(context, comment, post),
                        )
                        .toList()),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
