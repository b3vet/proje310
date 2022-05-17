import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user.dart';
import 'post_card.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({required this.user, Key? key}) : super(key: key);

  static const String routeName = '/profile';
  final User user;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<Post> posts = [
    Post(
      id: 'someuuid-1',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: ['uuid-1', 'uuid-2'],
      commentCount: 2,
      likeCount: 2,
      userId: 'uuid-99',
    ),
    Post(
      id: 'someuuid-2',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: ['uuid-1', 'uuid-2'],
      commentCount: 1,
      likeCount: 5,
      userId: 'uuid-99',
    ),
    Post(
      id: 'someuuid-3',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: ['uuid-1', 'uuid-2'],
      commentCount: 2,
      likeCount: 4,
      userId: 'uuid-99',
    ),
    Post(
      id: 'someuuid-4',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: ['uuid-1', 'uuid-2'],
      commentCount: 2,
      likeCount: 2,
      userId: 'uuid-99',
    ),
    Post(
      id: 'someuuid-5',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: ['uuid-1', 'uuid-2'],
      commentCount: 2,
      likeCount: 2,
      userId: 'uuid-99',
    ),
  ];

  late User user;
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  void deletePost(Post post) {
    setState(() {
      posts.remove(post);
    });
  }

  void incrementLikes(Post post) {
    setState(() {
      post.likeCount++;
      post.likedBy.add('uuid-34'); //add the uuid of the current user here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: ClipOval(
                          child: Image.network(
                            user.profilePictureUrl ?? 'empty',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        radius: 45,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/editProfile');
                      },
                      child: const Text('Edit Profile'),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text('@${user.username}'),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(user.bio == null ? '' : '${user.bio}\n'),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Text(
                                '0',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '0',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Posts'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Posts&Replies'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Media'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Likes'),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 4.0,
                  height: 15,
                ),
                Column(
                  //children: posts.map((post) => Text('${post.text}')).toList(),
                  //children: posts.map((post)=> Card(child:Text('${post.text}'))).toList(),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
