import 'package:cloud_firestore/cloud_firestore.dart';

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
}
