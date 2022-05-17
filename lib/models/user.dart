import 'package:json_annotation/json_annotation.dart';

import 'post.dart';

part 'user.g.dart';

@JsonSerializable()
class Geo {
  String lat;
  String lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) => _$GeoFromJson(json);
  Map<String, dynamic> toJson() => _$GeoToJson(this);
}

@JsonSerializable()
class Address {
  String street;
  String city;
  String suite;
  String zipcode;
  Geo geo;

  Address({
    required this.street,
    required this.city,
    required this.suite,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Topic {
  String topicName;
  String id;

  Topic({
    required this.topicName,
    required this.id,
  });

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

@JsonSerializable()
class User {
  String id;
  String name;
  String username;
  String email;

  String? profilePictureUrl;
  String? bio;

  @JsonKey(defaultValue: false)
  bool deactivated = false;

  bool publicAccount;

  List<Address> subscribedLocations;

  List<Topic> subscribedTopics;

  List<Post> posts =
      []; //this will be existing in data motel but not in database and will be populated when needed

  List<String> sharedPosts = []; //ids of shared posts

  List<String> bookmarkedPosts =
      []; //this is is a list of post ids that are bookmarked by the user

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.username,
      this.profilePictureUrl,
      required this.deactivated,
      required this.publicAccount,
      required this.subscribedLocations,
      required this.subscribedTopics,
      this.bio});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
