import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './utils/colors.dart';
import 'logic/user_provider.dart';
import 'ui/app_view.dart';
import 'ui/edit_profile.dart';
import 'ui/login.dart';
import 'ui/notifications_view.dart';
import 'ui/profile_view.dart';
import 'ui/profile_with_scaffold.dart';
import 'ui/signup.dart';
import 'ui/single_post_view.dart';
import 'ui/walkthrough.dart';
import 'ui/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool welcomeShownBefore = prefs.getBool('walkthroughShown') ?? false;
  runApp(
    MyApp(welcomeShownBefore: welcomeShownBefore),
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
  const MyApp({required this.welcomeShownBefore, Key? key}) : super(key: key);
  final bool welcomeShownBefore;

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SUConnect',
        theme: AppThemes.lightTheme,
        routes: {
          '/appView': (context) => const AppView(),
          '/welcome': (context) => const Welcome(),
          '/signup': (context) => const SignUp(),
          '/login': (context) => const Login(),
          '/profile': (context) => const ProfileView(),
          '/editProfile': (context) => const EditProfile(),
          '/notificationView': (context) => const NotificationView(),
          '/singlePostView': (context) => const SinglePostView(),
          '/standaloneProfileView': (context) => const StandaloneProfileView(),
        },
        home: welcomeShownBefore == false
            ? const WalkThrough()
            : const AuthenticationStatus(),
      ),
    );
  }
}

class AuthenticationStatus extends StatefulWidget {
  const AuthenticationStatus({Key? key}) : super(key: key);
  @override
  State<AuthenticationStatus> createState() => _AuthenticationStatusState();
}

class _AuthenticationStatusState extends State<AuthenticationStatus> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.user == null) {
          return const Welcome();
        } else {
          return const AppView();
        }
      },
    );
  }
}
