import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project310/services/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../services/cloud_storage.dart';

class UserProvider extends ChangeNotifier {
  UserProvider(AppUser? storedUser) {
    if (storedUser != null) {
      _user = storedUser;
    }
  }
  AppUser? _user;

  AppUser? get user => _user;

  static DB db = DB();

  static CloudStorage storage = CloudStorage();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<dynamic> login() async {
    late UserCredential creds;
    try {
      creds = await signInWithGoogle();
    } catch (e) {
      return e;
    }

    if (creds.user == null) {
      return null;
    }
    AppUser? user = await db.getUser(creds.user!.uid);

    if (user == null) {
      return null;
    }

    if (user.deactivated == true) {
      await db.reactivateUser(user);
      user.deactivated = false;
    }
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(_user!.toJson()));
    notifyListeners();
    return 1;
  }

  Future<dynamic> signup() async {
    late UserCredential creds;
    try {
      creds = await signInWithGoogle();
    } catch (e) {
      return e;
    }

    if (creds.user == null) {
      return null;
    }

    User firebaseUser = creds.user!;
    AppUser? checkuser = await db.getUser(firebaseUser.uid);

    if (checkuser != null) {
      await GoogleSignIn().disconnect();
      return 'An account linked with the used google account already exists. Please use login!';
    }
    AppUser user = AppUser(
      deactivated: false,
      email: firebaseUser.email!,
      id: firebaseUser.uid,
      name: firebaseUser.displayName!,
      publicAccount: true,
      subscribedLocations: [],
      subscribedTopics: [],
      username: 'not-set-yet',
      profilePictureUrl: firebaseUser.photoURL,
    );

    await db.saveUser(user);
    _user = user;
    return 1;
  }

  Future<void> deactivate() async {
    await db.deactivateUser(_user!);
    await logout();
  }

  Future<void> deleteAccount() async {
    await db.deleteUser(_user!);
    await logout();
  }

  Future<void> logout() async {
    await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    _user = null;
  }

  Future<void> addBioAndUsername(String id, String bio, String username) async {
    await db.updateUserBioAndUserName(id, bio, username);

    _user = _user!.copyWith(bio: bio, username: username);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(_user!.toJson()));
  }

  void addPost(Post post) {
    _user!.posts.add(post.id);
    notifyListeners();
  }

  void updateUser(AppUser user) {
    _user = user;
    notifyListeners();
  }

  Future<void> updateUserProfilePicture(XFile file) async {
    String newUrl = await storage.changeProfilePicture(_user!, file);
    await db.changeProfilePicture(_user!, newUrl);
    _user = _user!.copyWith(profilePictureUrl: newUrl);
    notifyListeners();
  }

  Future<void> removeProfilePicture() async {
    await db.removeProfilePicture(_user!);
    _user = _user!.copyWith(profilePictureUrl: null);
    notifyListeners();
  }

  Future<void> delete() async {
    await db.deleteUser(_user!);
    logout();
  }
}
