import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './utils/colors.dart';
import 'models/user.dart';
import 'ui/walkthrough.dart';
import 'ui/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool welcomeShownBefore = prefs.getBool('walkthroughShown') ?? false;
  runApp(MyApp(welcomeShownBefore: welcomeShownBefore));
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
    return MaterialApp(
      title: 'SUConnect',
      theme: AppThemes.lightTheme,
      routes: {
        '/welcome': (context) => const Welcome(),
        '/signup': (context) => const Dummy(),
        '/login': (context) => const Dummy(),
        '/test': (context) => const Dummy(),
      },
      home: welcomeShownBefore
          ? const WalkThrough()
          : const AuthenticationStatus(),
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
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const Welcome();
    } else {
      return const Dummy();
    }
  }
}
