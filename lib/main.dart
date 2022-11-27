import 'package:calendar_sync/themes/themes.dart';
import 'package:calendar_sync/views/day_page.dart';
import 'package:calendar_sync/views/homepage.dart';
import 'package:calendar_sync/views/onboarding.dart';
import 'package:calendar_sync/views/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'models/auth.dart';

bool continueToApp = false;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool dispOnBoardPage = prefs.getBool('navToHome') ??
      false; // Get the shared pref to determine if user has gone through onBoarding
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp(dispOnBoardPage: dispOnBoardPage));
}

class MyApp extends StatefulWidget {
  final bool dispOnBoardPage;

  const MyApp({super.key, required this.dispOnBoardPage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    // CalsyncGoogleOAuth().signIn();

    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 2));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 2));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 5));
    print('go!');
    FlutterNativeSplash.remove();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CalsyncThemeNotification(),
        ),
        ChangeNotifierProvider(
          create: (context) => CalsyncGoogleOAuth(),
        )
      ],
      child: Consumer<CalsyncThemeNotification>(builder:
          (BuildContext context, CalsyncThemeNotification notifier, child) {
        return MaterialApp(
          title: 'Calsync',
          theme: notifier.darkTheme ? CalsyncThemes.dark : CalsyncThemes.light,
          // theme: CalsyncThemes.light,
          // darkTheme: CalsyncThemes.dark,
          themeMode: ThemeMode.system,
          home: widget.dispOnBoardPage
              ? SignInPage(title: 'Calsync')
              : OnBoarding(),
          onGenerateRoute: (RouteSettings routeParam) {
            // https://youtu.be/-XMexZCMCzU
            // Auto generate routes by using patterns
            final List<String> path = routeParam.name!.split('/');
            if (path[0] != '') {
              print("Path: $path");
              return null;
            }

            switch (path[1]) {
              case 'signin':
                return MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SignInPage(title: "Calsync"));
              case 'day':
                return MaterialPageRoute(
                    builder: (BuildContext context) => DayPage());
              case 'homepage':
                // final String homePageParams = path[2];
                return MaterialPageRoute(
                    builder: (BuildContext context) => CalSyncHomePage());
              case 'settings':
                return MaterialPageRoute(
                    builder: (BuildContext context) => SettingsPage());
              default:
                return null;
            }
          },
        );
      }),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.title});

  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? _currentUser;
    return Consumer<CalsyncGoogleOAuth>(
        builder: (BuildContext context, notifier, child) {
      if (notifier.getCurrentUser != null) {
        _currentUser = notifier.getCurrentUser;
        // Navigator.pushReplacementNamed(context, '/homepage');

        return CalSyncHomePage();
      } else {
        return Container(
          color: Theme.of(context).primaryColorDark,
          child: Center(
            /*ADD A TITLE*/
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentUser != null
                      ? "Welcome \n ${_currentUser?.displayName}"
                      : "",
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text(
                  _currentUser != null
                      ? "${_currentUser?.email} is signed in"
                      : "",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Container(
                  child: notifier.getCurrentUser != null
                      ? Image.network(
                          notifier.getCurrentUser?.photoUrl as String,
                          height: 100,
                          cacheHeight: 100,
                          cacheWidth: 100,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.contain,
                          semanticLabel: notifier.getCurrentUser!.displayName,
                          width: 200,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : LinearProgressIndicator();
                          },
                        )
                      : Image.network(
                          "https://thecaninebuddy.com/ezoimgfmt/i0.wp.com/thecaninebuddy.com/wp-content/uploads/2021/08/crying-cat-meme.jpg?resize=1320%2C743&ssl=1&ezimgfmt=ngcb1/notWebP",
                          // crying cat
                          // "https://cdn3.emoji.gg/emojis/8825_cough.png", // coughing cat
                          height: 100,
                          cacheHeight: 100,
                          // cacheWidth: 40,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.contain,
                          semanticLabel: "userImage",
                          width: 200,
                          loadingBuilder: (context, child, progress) {
                            return progress == null
                                ? child
                                : LinearProgressIndicator();
                          },
                        ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (notifier.getCurrentUser != null) {
                      print(
                          "User email: ${notifier.getCurrentUser?.email as String}");
                      setState(() {
                        // CalsyncGoogleOAuth().signIn();
                        continueToApp = true;
                        Navigator.popAndPushNamed(context, '/homepage');
                        // CalsyncGoogleOAuth().getCalendars();
                      });
                    } else {
                      setState(() async {
                        notifier.signIn();
                        // if (await notifier.googleSignIn.isSignedIn()) {
                        Navigator.popAndPushNamed(context, '/homepage');
                        // }
                      });
                    }
                  },
                  child: Text("Sign In With Google"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pushNamed(context, '/homepage');
                      continueToApp = true;
                    });
                  },
                  child: Text("Continue"),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
