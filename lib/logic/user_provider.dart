import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user = User(
    id: 'someuuid',
    deactivated: false,
    subscribedLocations: [],
    name: 'tester user',
    email: 'tester@gmail.com',
    username: 'testerrr123',
    publicAccount: true,
    subscribedTopics: [],
    bio: 'Uzun bir bio deneme hello testing',
    profilePictureUrl: 'https://cdn.bolgegundem.com/d/gallery/9472_2.jpg',
  );

  User? get user => _user;

  void add(User user) {
    _user = user;
    notifyListeners();
  }

  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }
}
