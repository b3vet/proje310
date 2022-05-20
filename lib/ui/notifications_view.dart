import 'package:flutter/material.dart';

import '../models/notification.dart';
import '../models/user.dart';
import '../utils/dummy_data.dart';
import '../utils/styles.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User subjectUser = DummyData.users
        .firstWhere((element) => element.id == notification.subjectId);
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    subjectUser.profilePictureUrl ?? 'empty',
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  subjectUser.name + ' @' + subjectUser.username,
                  style: kLabelStyle,
                ),
              ],
            ),
            Text(
              notification.type == 'share'
                  ? 'shared your tweet: '
                  : 'liked your tweet: ',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              DummyData.posts
                  .firstWhere((element) => element.id == notification.postId)
                  .text,
            )
          ],
        ),
      ),
    );
  }
}

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> {
  final List<AppNotification> notifs = DummyData.notifs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: notifs
              .map(
                (notification) => NotificationCard(
                  notification: notification,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}