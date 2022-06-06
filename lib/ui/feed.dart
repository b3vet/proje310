import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/user_provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/analytics.dart';
import '../services/db.dart';
import '../utils/dummy_data.dart';
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
    return _postListView(provider.user!);
  }

  void incrementLike(Post post, AppUser user) {
    setState(() {
      post.likeCount++;
      post.likedBy.add(user.id);
    });
  }

  void showAddPost(BuildContext context, DB db, AppUser user) {
    String postText = '';
    showModalBottomSheet(
      context: context,
      builder: (buildContext) {
        return SizedBox(
          height: screenHeight(context),
          width: screenWidth(context),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('cancel'),
                    onPressed: () {
                      Navigator.pop(buildContext);
                    },
                  ),
                  TextButton(
                    child: const Text('post'),
                    onPressed: () async {
                      Post toSend = Post(
                        id: 'dummyid',
                        text: postText,
                        likedBy: [],
                        comments: [],
                        userId: user.id,
                        commentCount: 0,
                        likeCount: 0,
                        shareCount: 0,
                      );
                      await db.addPost(toSend, user);
                      Navigator.pop(buildContext);
                      setState(() {});
                    },
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: screenWidth(context),
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  maxLength: 255,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onChanged: (value) {
                    postText = value;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _postListView(AppUser user) {
    final DB db = DB();
    Future<List<Post>?> feedPosts = db.getFeed(user);
    return FutureBuilder<List<Post>?>(
      future: feedPosts,
      builder: (BuildContext context, AsyncSnapshot<List<Post>?> snapshot) {
        print(snapshot.data);
        if (snapshot.hasData) {
          if (snapshot.data == null ||
              (snapshot.data != null && snapshot.data!.isEmpty)) {
            return Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No one you follow shared a post before! Follow some accounts to see posts!',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        color: Colors.white,
                        onPressed: () {
                          showAddPost(context, db, user);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Stack(children: [
            ListView.builder(
              itemBuilder: ((context, index) => PostCard(
                    incrementLike: incrementLike,
                    post: snapshot.data![index],
                  )),
              itemCount: snapshot.data!.length,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Ink(
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      showAddPost(context, db, user);
                    },
                  ),
                ),
              ),
            ),
          ]);
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Unexpected Error'),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Text('Loading..'),
            ],
          );
        }
      },
    );
  }
}
