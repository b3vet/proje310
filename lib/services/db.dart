import 'package:firebase_database/firebase_database.dart';

import '../models/user.dart';

class DB {
  static FirebaseDatabase database = FirebaseDatabase.instance;

  Future<void> saveUser(AppUser user) async {
    DatabaseReference ref = database.ref('users/${user.id}');
    await ref.set(user.toJson());
  }

  Future<AppUser?> getUser(String id) async {
    final ref = database.ref();
    final snapshot = await ref.child('users/$id').get();
    if (snapshot.exists) {
      return AppUser.fromJson(snapshot.value as Map<String, dynamic>);
    } else {
      return null;
    }
  }
}
