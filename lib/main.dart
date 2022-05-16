import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './utils/colors.dart';
import 'models/user.dart';
import 'ui/edit_profile.dart';
import 'ui/login.dart';
import 'ui/profile_view.dart';
import 'ui/signup.dart';
import 'ui/walkthrough.dart';
import 'ui/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool welcomeShownBefore = prefs.getBool('walkthroughShown') ?? false;
  print(welcomeShownBefore);
  User user = User(
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
  runApp(
    MyApp(welcomeShownBefore: welcomeShownBefore, user: user),
  );
}

class Dummy extends StatelessWidget {
  const Dummy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('dummy page'));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({required this.welcomeShownBefore, required this.user, Key? key})
      : super(key: key);
  final bool welcomeShownBefore;
  final User user;

  //final Future<FirebaseApp> _init = Firebase.initializeApp(); will be added
  /*
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen(message: snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<User?>.value(
            value: AuthService().user,
            initialData: null,
            child: AuthenticationStatus(),
          );
        }
        return const WaitingScreen();
      },
    );
    THESE PARTS WILL BE ADDED IN THE NEXT STEP
  } */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUConnect',
      theme: AppThemes.lightTheme,
      routes: {
        '/welcome': (context) => const Welcome(),
        '/signup': (context) => const SignUp(),
        '/login': (context) => const Login(),
        '/profile': (context) => ProfileView(user: user),
        '/editProfile': (context) => EditProfile(user: user)
      },
      home: welcomeShownBefore == false
          ? const WalkThrough()
          : AuthenticationStatus(user: user),
    );
  }
}

class AuthenticationStatus extends StatefulWidget {
  const AuthenticationStatus({required this.user, Key? key}) : super(key: key);
  final User user;
  @override
  State<AuthenticationStatus> createState() => _AuthenticationStatusState();
}

class _AuthenticationStatusState extends State<AuthenticationStatus> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const Welcome();
    } else {
      return ProfileView(user: widget.user);
    }
  }
}
