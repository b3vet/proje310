import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/analytics.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({Key? key}) : super(key: key);

  @override
  _WalkThroughState createState() => _WalkThroughState();
  static const String routeName = '/walkthrough';
}

class _WalkThroughState extends State {
  int page = 1, totalPage = 4;
  List<String> appBarTitles = ['WELCOME', 'INTRO', 'PROFILES', 'CONTENT'];
  List<String> pageTitles = [
    'The Best Social Media Platform',
    'Signup easily',
    'Create your profile',
    'Start meeting new people'
  ];
  List<String> imageUrls = [
    'https://adtechresources.com/wp-content/uploads/2020/02/Mobile-Application.jpeg',
    'https://cdn3.vectorstock.com/i/1000x1000/52/62/sign-up-page-purple-gradient-registration-form-vector-23745262.jpg',
    'https://i.pinimg.com/originals/48/19/e7/4819e7f441969c82703447ecd2107cbe.png',
    'https://www.reveantivirus.com/blog/wp-content/uploads/2019/12/Untitled-2.jpg'
  ];
  List<String> imageCaptions = [
    'Welcome to your social world',
    'Just use your SU-Net account',
    'Design your profile to find your friends',
    'Connect with your friends and new people'
  ];

  void nextPage() {
    setState(() {
      if (page != 4) {
        page++;
      }
    });
  }

  void prevPage() {
    setState(() {
      if (page != 1) {
        page--;
      }
    });
  }

  void goToWelcome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('walkthroughShown', true);
    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    AppAnalytics.setCurrentName('Walkthrough');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitles[page - 1],
          style: const TextStyle(letterSpacing: -1),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pageTitles[page - 1],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            //Image.network(imageUrls[page-1],),
            CircleAvatar(
              backgroundColor: const Color(0xFFF2F2F7),
              radius: 200,
              backgroundImage: NetworkImage(
                imageUrls[page - 1],
              ),
            ),
            Text(
              imageCaptions[page - 1],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
                letterSpacing: -1,
                color: Color(0xFF757575),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: prevPage,
                  child: const Text(
                    'Prev',
                  ),
                ),
                Text('$page/$totalPage'),
                OutlinedButton(
                  onPressed: page == totalPage ? goToWelcome : nextPage,
                  child: Text(
                    page == totalPage ? 'Go to Welcome' : 'Next',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
