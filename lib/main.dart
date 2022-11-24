import 'package:calendar_sync/themes/themes.dart';
import 'package:calendar_sync/views/homepage.dart';
import 'package:calendar_sync/views/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/auth.dart';

bool continueToApp = false;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            theme:
                notifier.darkTheme ? CalsyncThemes.dark : CalsyncThemes.light,
            // theme: CalsyncThemes.light,
            // darkTheme: CalsyncThemes.dark,
            // themeMode: ThemeMode.system,
            home: const SignInPage(title: 'Calsync'),
            onGenerateRoute: (RouteSettings routeParam) {
              // https://youtu.be/-XMexZCMCzU
              // Auto generate routes by using patterns
              final List<String> path = routeParam.name!.split('/');
              if (path[0] != '') {
                print("Path: $path");
                return null;
              }

              switch (path[1]) {
                // case 'schedule':
                //   return MaterialPageRoute(
                //       builder: (BuildContext context) => SchedulePage());
                // case 'day':
                //   return MaterialPageRoute(
                //       builder: (BuildContext context) => DayPage());
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
        }));
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.title});

  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final List<Widget> aboutBoxChildren = <Widget>[
    const SizedBox(height: 24),
    RichText(
      text: const TextSpan(
        children: <TextSpan>[
          TextSpan(
              // style: textStyle,
              text: "Flutter is Google's UI toolkit for building beautiful, "
                  'natively compiled applications for mobile, web, and desktop '
                  'from a single codebase. Learn more about Flutter at '),
          TextSpan(
              // style: textStyle.copyWith(color: theme.colorScheme.primary),
              text: 'https://flutter.dev'),
          // TextSpan(style: textStyle, text: '.'),
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    //initialization();
    // FlutterNativeSplash.remove();
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
    await Future.delayed(const Duration(seconds: 2));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    String text = "No one";
    return Consumer<CalsyncGoogleOAuth>(
        builder: (BuildContext context, notifier, child) {
      if (notifier.currentUser != null) {
        text = notifier.currentUser?.email as String;
      }
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (notifier.getCurrentUser != null) {
                    print(notifier.getCurrentUser?.email as String);
                    setState(() {
                      // CalsyncGoogleOAuth().signIn();
                      continueToApp = true;
                      Navigator.pushNamed(context, '/homepage');
                      // CalsyncGoogleOAuth().getCalendars();
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
              Text("${text} is signed in"),
            ],
          ),
        ),
      );
    });
  }
}
