import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/user_provider.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/analytics.dart';
import '../utils/dummy_data.dart';
import 'post_card.dart';

Widget _searchIcon() {
  return IconButton(
      onPressed: () => print('Search'),
      icon: const Padding(
        padding: EdgeInsets.all(14.0),
        child: Icon(Icons.search),
      ));
}

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late String searchTerm;
  late List<Post> filteredPosts;

  @override
  initState() {
    super.initState();
    searchTerm = '';
    filteredPosts = [];
  }

  void onSearchChange(String value) {
    setState(() {
      searchTerm = value;
      if (searchTerm == '') {
        filteredPosts = [];
      } else {
        filteredPosts = DummyData.posts
            .where(
              (element) => element.text.toLowerCase().contains(
                    searchTerm.toLowerCase(),
                  ),
            )
            .toList();
      }
    });
  }

  Widget _searchInput() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            onChanged: onSearchChange,
          ),
        ],
      ),
    );
  }

  void incrementLike(Post post, AppUser user) {
    setState(
      () {
        post.likeCount++;
        post.likedBy.add(user.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppAnalytics.setCurrentName('Search Screen');
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _searchInput(),
                ),
                _searchIcon()
              ],
            ),
          ),
          ...filteredPosts.map((post) {
            return PostCard(
              post: post,
              incrementLike: incrementLike,
            );
          }).toList(),
        ],
      ),
    );
  }
}
