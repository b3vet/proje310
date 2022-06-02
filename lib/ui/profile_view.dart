import 'package:flutter/material.dart';
import 'package:project310/ui/posts_tab.dart';
import 'package:provider/provider.dart';

import '../logic/user_provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/analytics.dart';
import '../utils/dummy_data.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key? key,
    this.user,
  }) : super(key: key);

  final AppUser? user;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  void incrementLikes(Post post, AppUser user) {
    setState(() {
      post.likeCount++;
      post.likedBy.add(user.id);
    });
  }

  late TabController _controller;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    AppAnalytics.setCurrentName('Profile Screen');
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final bool ownUser = widget.user == null ||
            (widget.user != null && widget.user!.id == userProvider.user!.id);
        final AppUser user = ownUser ? userProvider.user! : widget.user!;
        print(user.id);
        List<Post> userPosts = DummyData.posts
            .where(
              (element) => element.userId == user.id,
            )
            .toList();
        return SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: false,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        userDetailsColumnWidget(user, ownUser),
                      ],
                    ),
                  ),
                  expandedHeight: 310.0,
                  bottom: TabBar(
                    controller: _controller,
                    labelColor: Theme.of(context).primaryColor,
                    tabs: const [
                      Tab(
                        text: 'Posts',
                      ),
                      Tab(
                        text: 'Posts & Replies',
                      ),
                      Tab(
                        text: 'Media',
                      ),
                      Tab(
                        text: 'Likess',
                      ),
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              controller: _controller,
              children: [
                PostsTab(
                  posts: userPosts,
                  incrementLikes: incrementLikes,
                ),
                PostsTab(
                  posts: userPosts,
                  incrementLikes: incrementLikes,
                ),
                PostsTab(
                  posts: userPosts,
                  incrementLikes: incrementLikes,
                ),
                PostsTab(
                  posts: userPosts,
                  incrementLikes: incrementLikes,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget userDetailsColumnWidget(
    AppUser user,
    bool ownUser,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
              ownUser
                  ? OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/editProfile');
                      },
                      child: const Text('Edit Profile'),
                    )
                  : const SizedBox.shrink(),
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
        ],
      ),
    );
  }
}


/*

NestedScrollView(
            // controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                getAppbar(),
                authstate.isbusy
                    ? _emptyBox()
                    : SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          child: authstate.isbusy
                              ? const SizedBox.shrink()
                              : UserNameRowWidget(
                                  user: authstate.profileUserModel,
                                  isMyProfile: isMyProfile,
                                ),
                        ),
                      ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        color: TwitterColor.white,
                        child: TabBar(
                          indicator: TabIndicator(),
                          controller: _tabController,
                          tabs: const <Widget>[
                            Text("Tweets"),
                            Text("Tweets & replies"),
                            Text("Media")
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                /// Display all independent tweers list
                _tweetList(context, authstate, list, false, false),

                /// Display all reply tweet list
                _tweetList(context, authstate, list, true, false),

                /// Display all reply and comments tweet list
                _tweetList(context, authstate, list, false, true)
              ],
            ),
          ),

*/
/** 
 SingleChildScrollView(
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
                          Navigator.pushNamed(context, '/editProfile');
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
                    children: [
                      TabBar(
                        controller: _controller,
                        tabs: const [
                          Tab(
                            text: 'Posts',
                          ),
                          Tab(
                            text: 'Posts & Replies',
                          ),
                          Tab(
                            text: 'Media',
                          ),
                          Tab(
                            text: 'Likess',
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            PostsTab(
                              posts: posts,
                              incrementLikes: incrementLikes,
                              deletePost: deletePost,
                              user: user,
                            ),
                            PostsTab(
                              posts: posts,
                              incrementLikes: incrementLikes,
                              deletePost: deletePost,
                              user: user,
                            ),
                            PostsTab(
                              posts: posts,
                              incrementLikes: incrementLikes,
                              deletePost: deletePost,
                              user: user,
                            ),
                            PostsTab(
                              posts: posts,
                              incrementLikes: incrementLikes,
                              deletePost: deletePost,
                              user: user,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
*/