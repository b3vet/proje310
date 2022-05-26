import 'package:firebase_core/firebase_core.dart';
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

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({Key? key}) : super(key: key);

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Duration _duration;
  late Tween<double> _tween;

  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _tween = Tween(begin: 0.25, end: 1.0);
    _duration = const Duration(milliseconds: 1500);
    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    final CurvedAnimation curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    _animation = _tween.animate(curve);
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: const Image(
            image: AssetImage('assets/SUConnect-logos_transparent.png'),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key, required this.message}) : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({required this.welcomeShownBefore, Key? key}) : super(key: key);
  final bool welcomeShownBefore;

  final Future<FirebaseApp> _init = Firebase.initializeApp();
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
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: ErrorScreen(
              message: snapshot.error.toString(),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return errorlessApp();
        }
        return const MaterialApp(home: WaitingScreen());
      },
    );
  }

  Widget errorlessApp() {
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
