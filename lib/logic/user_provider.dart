import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _user;

  AppUser? get user => _user;

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
    //dbconnection.getUserDetails(creds.user!.uid); //next step if this returns null the user is not signed up
    User firebaseUser = creds.user!;
    AppUser user = AppUser(
      deactivated: false,
      email: firebaseUser.email!,
      id: firebaseUser.uid,
      name: firebaseUser.displayName!,
      publicAccount: true,
      subscribedLocations: [],
      subscribedTopics: [],
      username: 'b3vet',
      bio: 'This is my crazy bio!',
      profilePictureUrl: firebaseUser.photoURL,
    );
    _user = user;
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
    _user = user;
    return 1;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
  }

  Future<void> addBioAndUsername(String bio, String username) async {
    //dbconnection.updateUser(bio, username); next step

    _user = _user!.copyWith(bio: bio, username: username);
  }

  void updateUser(AppUser user) {
    _user = user;
    notifyListeners();
  }
}
