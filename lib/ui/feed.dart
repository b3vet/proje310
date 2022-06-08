import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/user_provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/analytics.dart';
import '../services/db.dart';
import '../utils/screenSizes.dart';
import 'post_card.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  @override
  Widget build(BuildContext context) {
    AppAnalytics.setCurrentName('Feed Screen');
    final provider = Provider.of<UserProvider>(
      context,
      listen: true,
    );
    return _postListView(provider.user!, context);
  }

  Future<void> incrementLike(Post post, AppUser user) async {
    final DB db = DB();
    if (post.likedBy.any((element) => element == user.id)) {
      db.decrementLike(post, user);
      setState(() {
        post.likeCount--;
        post.likedBy.remove(user.id);
      });
    } else {
      db.incrementLike(post, user);
      setState(() {
        post.likeCount++;
        post.likedBy.add(user.id);
      });
    }
  }

  Widget _postListView(AppUser user, BuildContext parentContext) {
    final DB db = DB();
    Future<List<Post>?> feedPosts = db.getFeed(user);
    return FutureBuilder<List<Post>?>(
      future: feedPosts,
      builder: (BuildContext context, AsyncSnapshot<List<Post>?> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Unexpected Error'),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: screenHeight(parentContext),
            width: screenWidth(parentContext),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Text('Loading..'),
              ],
            ),
          );
        }

        if (snapshot.data == null ||
            (snapshot.data != null && snapshot.data!.isEmpty)) {
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No one you follow shared a post before! Follow some accounts to see posts!',
                ),
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView.builder(
            itemBuilder: ((context, index) => PostCard(
                  incrementLike: incrementLike,
                  post: snapshot.data![index],
                )),
            itemCount: snapshot.data!.length,
          ),
        );
      },
    );
  }
}
