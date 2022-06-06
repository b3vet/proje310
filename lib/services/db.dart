import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';
import '../models/user.dart';

class DB {
  Future<void> saveUser(AppUser user) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    await ref.doc(user.id).set(user.toJson());
    print('user saved');
  }

  Future<AppUser?> getUser(String id) async {
    final ref = FirebaseFirestore.instance.collection('users');
    final snapshot = await ref.doc(id).get();
    if (snapshot.exists) {
      return AppUser.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> updateUserBioAndUserName(
      String id, String? bio, String username) async {
    final ref = FirebaseFirestore.instance.collection('users');
    await ref.doc(id).update({
      'username': username,
      'bio': bio,
    });
  }

  Future<List<Post>?> getFeed(AppUser user) async {
    final postsRef = FirebaseFirestore.instance.collection('posts');
    final usersRef = FirebaseFirestore.instance.collection('users');
    final connectionRef = FirebaseFirestore.instance.collection('connections');
    late QuerySnapshot<Map<String, dynamic>> followedUsersResult;
    try {
      followedUsersResult = await connectionRef
          .where('subject', isEqualTo: user.id)
          .where('type', isEqualTo: 'connected')
          .get();
    } catch (e) {
      return null;
    }
    List<String> followedUserIds = followedUsersResult.docs
        .map((document) => document.data()['target'] as String)
        .toList();
    late QuerySnapshot<Map<String, dynamic>> getPostsUsersResult;
    List<List<String>?> arrayChunks = [];
    for (var i = 0; i < followedUserIds.length; i += 10) {
      arrayChunks.add(
        followedUserIds.sublist(
          i,
          i + 10 < followedUserIds.length ? i + 10 : followedUserIds.length,
        ),
      );
    }
    List<Post> feedPosts = [];
    try {
      for (var i = 0; i < arrayChunks.length; i++) {
        getPostsUsersResult =
            await postsRef.where('userId', whereIn: arrayChunks[i]).get();
        feedPosts.addAll(getPostsUsersResult.docs
            .map((document) => Post.fromJson(document.data()))
            .toList());
      }
    } catch (e) {
      return null;
    }
    List<Post> sharedPosts = [];
    for (var i = 0; i < followedUserIds.length; i++) {
      try {
        AppUser sharingUser = AppUser.fromJson(
            (await usersRef.doc(followedUserIds[i]).get()).data()!);
        List<String> sharedPostIds = sharingUser.sharedPosts;
        if (sharedPostIds.isNotEmpty) {
          for (final id in sharedPostIds) {
            Post temp = Post.fromJson(
              (await postsRef.doc(id).get()).data()!,
            );
            temp.sharedBy = '@${sharingUser.username}';
            sharedPosts.add(temp);
          }
        }
      } catch (e) {
        return null;
      }
    }

    late QuerySnapshot<Map<String, dynamic>> getUsersPostsResult;
    List<List<String>?> userPostsArrayChunk = [];
    for (var i = 0; i < user.posts.length; i += 10) {
      userPostsArrayChunk.add(
        user.posts.sublist(
          i,
          i + 10 < user.posts.length ? i + 10 : user.posts.length,
        ),
      );
    }
    List<Post> userPosts = [];
    print(user.posts);
    try {
      for (var i = 0; i < userPostsArrayChunk.length; i++) {
        getUsersPostsResult =
            await postsRef.where('userId', whereIn: arrayChunks[i]).get();
        userPosts.addAll(getUsersPostsResult.docs
            .map((document) => Post.fromJson(document.data()))
            .toList());
      }
    } catch (e) {
      return null;
    }

    List<Post> returnList = [...feedPosts, ...sharedPosts, ...userPosts];
    returnList.sort((a, b) => a.id.compareTo(b.id));
    return returnList;
  }

  Future<void> addPost(Post post, AppUser user) async {
    final postsRef = FirebaseFirestore.instance.collection('posts');
    final usersRef = FirebaseFirestore.instance.collection('users');
    await usersRef.doc(user.id).update({
      'posts': FieldValue.arrayUnion([post.id])
    });
    post.id = postsRef.doc().id;
    await postsRef.doc(post.id).set(post.toJson());
  }
}
