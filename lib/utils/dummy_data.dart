import '../models/notification.dart';
import '../models/post.dart';
import '../models/user.dart';

class DummyData {
  static List<Post> posts = [
    Post(
      id: 'someuuid-1',
      text: 'Wow. It is crazy good yeah!!!',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: [],
      commentCount: 0,
      likeCount: 2,
      userId: 'uuid-99',
    ),
    Post(
      id: 'someuuid-2',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2', 'uuid-3', 'uuid-4', 'uuid-5'],
      comments: [],
      commentCount: 0,
      likeCount: 5,
      userId: 'uuid-98',
    ),
    Post(
      id: 'someuuid-3',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2', 'uuid-3', 'uuid-4'],
      comments: [],
      commentCount: 0,
      likeCount: 4,
      userId: 'uuid-97',
    ),
    Post(
      id: 'someuuid-4',
      text:
          'Su lambaya bakin harika ampullere bayilirim! Cok seviyorumbu hayati!!',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: [],
      commentCount: 0,
      likeCount: 2,
      userId: 'f1x00kUTjBNCY17VfaiiPz0FGbH2',
      imageUrl:
          'https://cdn.cimri.io/image/1000x1000/philipsessentialwebeyazledlamba_205832953.jpg',
    ),
    Post(
      id: 'someuuid-5',
      text:
          'Telefonum geldi harika oldugunu dusunuyorum. Bu yuzden bu postu cok uzun uzun yaziyorum ki baya uzun olsun. Mesela telefon gorseli de koydum eskiden tivitirda gorsel ekleyince karakter sayisi azalirdi cunku link ekleniyodu tivite??',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: ['someuuid-11', 'someuuid-12'],
      commentCount: 2,
      likeCount: 2,
      userId: 'f1x00kUTjBNCY17VfaiiPz0FGbH2',
      imageUrl:
          'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-13-midnight-select-2021?wid=940&hei=1112&fmt=png-alpha&.v=1645572315913',
    ),
    Post(
      id: 'someuuid-6',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: [],
      commentCount: 0,
      likeCount: 2,
      userId: 'f1x00kUTjBNCY17VfaiiPz0FGbH2',
    ),
    Post(
      id: 'someuuid-7',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: [],
      commentCount: 0,
      likeCount: 5,
      userId: 'f1x00kUTjBNCY17VfaiiPz0FGbH2',
    ),
    Post(
      id: 'someuuid-8',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: [],
      commentCount: 0,
      likeCount: 4,
      userId: 'f1x00kUTjBNCY17VfaiiPz0FGbH2',
    ),
    Post(
      id: 'someuuid-9',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: [],
      commentCount: 0,
      likeCount: 2,
      userId: 'f1x00kUTjBNCY17VfaiiPz0FGbH2',
    ),
    Post(
      id: 'someuuid-10',
      text: 'Merhaba denem test yey',
      likedBy: ['uuid-1', 'uuid-2'],
      comments: [],
      commentCount: 0,
      likeCount: 2,
      userId: 'f1x00kUTjBNCY17VfaiiPz0FGbH2',
    ),
    Post(
      id: 'someuuid-11',
      text: 'cok iyi bir post olmus ellerinize saglik',
      likedBy: [],
      comments: [],
      commentCount: 0,
      likeCount: 0,
      userId: 'uuid-97',
      commentToId: 'someuuid-5',
    ),
    Post(
      id: 'someuuid-12',
      text:
          'cok iyi bir post olmus ellerinize saglik tekrardan tebrikler gercekten hayran kaldim ellerinize saglik',
      likedBy: [],
      comments: [],
      commentCount: 0,
      likeCount: 0,
      userId: 'uuid-97',
      commentToId: 'someuuid-5',
    ),
  ];

  static List<AppUser> users = [
    AppUser(
      id: 'uuid-99',
      name: 'Crazy Guy',
      email: 'myemail1@gmail.com',
      deactivated: false,
      publicAccount: true,
      subscribedLocations: [],
      subscribedTopics: [],
      username: 'crazyguy68',
      bio: 'I am a crazy guy welcome to my account!',
      profilePictureUrl:
          'https://media.moddb.com/images/members/5/4550/4549205/duck.jpg',
    ),
    AppUser(
      id: 'uuid-98',
      name: 'Crazy Guy 2',
      email: 'myemail2@gmail.com',
      deactivated: false,
      publicAccount: true,
      subscribedLocations: [],
      subscribedTopics: [],
      username: 'crazyguy72',
      bio: 'I am a crazy guy 2 welcome to my account!',
      profilePictureUrl:
          'https://media.moddb.com/images/members/5/4550/4549205/duck.jpg',
    ),
    AppUser(
      id: 'uuid-97',
      name: 'Crazy Guy 3',
      email: 'myemail3@gmail.com',
      deactivated: false,
      publicAccount: true,
      subscribedLocations: [],
      subscribedTopics: [],
      username: 'crazyguy74',
      bio: 'I am a crazy guy 3 welcome to my account!',
      profilePictureUrl:
          'https://media.moddb.com/images/members/5/4550/4549205/duck.jpg',
    ),
    AppUser(
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
    ),
    AppUser(
      id: 'f1x00kUTjBNCY17VfaiiPz0FGbH2',
      name: 'Crazy Guy',
      email: 'myemail1@gmail.com',
      deactivated: false,
      publicAccount: true,
      subscribedLocations: [],
      subscribedTopics: [],
      username: 'b3vet',
      bio: 'I am a crazy guy welcome to my account!',
      profilePictureUrl:
          'https://media.moddb.com/images/members/5/4550/4549205/duck.jpg',
    ),
  ];

  static List<AppNotification> notifs = [
    AppNotification(
      id: 'someuuid-1',
      postId: 'someuuid-1',
      subjectId: 'uuid-99',
      type: 'like',
    ),
    AppNotification(
      id: 'someuuid-2',
      postId: 'someuuid-1',
      subjectId: 'uuid-98',
      type: 'share',
    ),
    AppNotification(
      id: 'someuuid-3',
      postId: 'someuuid-1',
      subjectId: 'uuid-97',
      type: 'like',
    ),
    AppNotification(
      id: 'someuuid-4',
      postId: 'someuuid-1',
      subjectId: 'uuid-97',
      type: 'like',
    ),
    AppNotification(
      id: 'someuuid-5',
      postId: 'someuuid-1',
      subjectId: 'uuid-99',
      type: 'share',
    ),
    AppNotification(
      id: 'someuuid-4',
      postId: 'someuuid-1',
      subjectId: 'uuid-97',
      type: 'like',
    ),
    AppNotification(
      id: 'someuuid-1',
      postId: 'someuuid-6',
      subjectId: 'uuid-98',
      type: 'like',
    ),
    AppNotification(
      id: 'someuuid-2',
      postId: 'someuuid-7',
      subjectId: 'uuid-97',
      type: 'share',
    ),
    AppNotification(
      id: 'someuuid-3',
      postId: 'someuuid-8',
      subjectId: 'uuid-99',
      type: 'like',
    ),
  ];
}
