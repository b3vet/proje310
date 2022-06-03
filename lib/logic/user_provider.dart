import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project310/services/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  UserProvider(AppUser? storedUser) {
    if (storedUser != null) {
      _user = storedUser;
    }
  }
  AppUser? _user;

  AppUser? get user => _user;

  static DB db = DB();

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
    print('user saved');
    _user = user;
    return 1;
  }

  Future<void> logout() async {
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

  void updateUser(AppUser user) {
    _user = user;
    notifyListeners();
  }
}
