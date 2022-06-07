import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/user_provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/db.dart';
import '../utils/screenSizes.dart';
import 'feed.dart';
import 'notifications_view.dart';
import 'profile_view.dart';
import 'search.dart';

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);
  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  int _selectedIndex = 0;

  static late List<Widget> _pages;

  @override
  void initState() {
    _pages = <Widget>[
      const FeedView(),
      const SearchView(),
      const NotificationView(),
      const ProfileView(),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showAddPost(BuildContext context, AppUser user) {
    DB db = DB();
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

  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<UserProvider>(context, listen: false).user!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUConnect'),
        actions: [
          if (_selectedIndex == 3)
            IconButton(
              icon: const Icon(Icons.logout_outlined),
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false)
                    .logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/welcome',
                  (route) => false,
                );
              },
            ),
          if (_selectedIndex == 0)
            TextButton(
              child: Text(
                'Add Post',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Colors.white,
                    ),
              ),
              onPressed: () {
                showAddPost(context, user);
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      ),
    );
  }
}
