import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../logic/user_provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/analytics.dart';
import '../services/db.dart';
import '../utils/screenSizes.dart';
import 'post_card.dart';

class AddPostModalSheetView extends StatefulWidget {
  const AddPostModalSheetView({Key? key, required this.user}) : super(key: key);
  final AppUser user;

  @override
  State<AddPostModalSheetView> createState() => _AddPostModalSheetViewState();
}

class _AddPostModalSheetViewState extends State<AddPostModalSheetView> {
  File? image;
  File? video;
  String postText = '';
  final DB db = DB();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new post'),
        centerTitle: false,
      ),
      body: SizedBox(
        height: screenHeight(context),
        width: screenWidth(context),
        child: Column(
          children: [
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
            if (image != null)
              Container(
                padding: const EdgeInsets.all(8),
                width: screenWidth(context),
                child: Image.file(
                  image!,
                ),
              ),
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                ClipOval(
                  child: Material(
                    color: Theme.of(context).primaryColor, // Button color
                    child: InkWell(
                      splashColor: Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor, // Splash color
                      onTap: () async {
                        ImagePicker picker = ImagePicker();
                        XFile? pickedImage =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedImage != null) {
                          setState(() {
                            video = null;
                            image = File(pickedImage.path);
                          });
                        }
                      },
                      child: const SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: Theme.of(context).primaryColor, // Button color
                    child: InkWell(
                      splashColor: Theme.of(context)
                          .bottomNavigationBarTheme
                          .unselectedItemColor, // Splash color
                      onTap: () async {
                        try {
                          ImagePicker picker = ImagePicker();
                          XFile? pickedVideo = await picker.pickVideo(
                              source: ImageSource.gallery,
                              maxDuration: const Duration(seconds: 120));
                          if (pickedVideo != null) {
                            VideoPlayerController testLengthController =
                                VideoPlayerController.file(
                                    File(pickedVideo.path));
                            await testLengthController.initialize();
                            if (testLengthController.value.duration.inSeconds >
                                120) {
                              pickedVideo = null;
                              testLengthController.dispose();
                              throw ('We only allow videos that are shorter than 2 minutes!');
                            } else {
                              setState(() {
                                image = null;
                                video = File(pickedVideo!.path);
                              });
                            }
                          }
                        } catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    child: Text(e.toString()),
                                  ),
                                );
                              });
                          return;
                        }
                      },
                      child: const SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.video_call_outlined,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Post toSend = Post(
            id: 'dummyid',
            text: postText,
            likedBy: [],
            comments: [],
            userId: widget.user.id,
            commentCount: 0,
            likeCount: 0,
            shareCount: 0,
          );
          Post sentPost = await db.addPost(toSend, widget.user, image, video);
          Provider.of<UserProvider>(context, listen: false).addPost(sentPost);
          Navigator.pop(context);
        },
        child: const Text('post'),
      ),
    );
  }
}

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
    final DB db = DB();
    AppUser user = provider.user!;
    Future<List<Post>?> feedPosts = db.getFeed(user);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalPopup(
              context: context,
              builder: (context) => AddPostModalSheetView(user: user));
        },
        child: const Icon(
          Icons.add_outlined,
        ),
      ),
      body: FutureBuilder<List<Post>?>(
        future: feedPosts,
        builder: (BuildContext context, AsyncSnapshot<List<Post>?> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unexpected Error'),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: screenHeight(context),
              width: screenWidth(context),
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
      ),
    );
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
}
