import '../models/post.dart';
import '../models/user.dart';

class SinglePostViewArguments {
  final Post post;

  SinglePostViewArguments({required this.post});
}

class StandaloneProfileViewArguments {
  final AppUser? user;
  StandaloneProfileViewArguments({this.user});
}
