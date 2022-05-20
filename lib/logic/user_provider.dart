import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user = User(
    id: 'uuid-96',
    name: 'TOSKO',
    email: 'myemail4@gmail.com',
    deactivated: false,
    publicAccount: true,
    subscribedLocations: [],
    subscribedTopics: [],
    username: 'crazyguy68',
    bio: 'I am a crazy guy 4 welcome to my account!',
    profilePictureUrl:
        'https://im.haberturk.com/2019/12/27/ver1577449006/2553553_810x458.jpg',
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
