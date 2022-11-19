import 'package:calsync/themes/themes.dart';
import 'package:calsync/views/day_page.dart';
import 'package:calsync/views/month_page.dart';
import 'package:calsync/views/schedule_page.dart';
import 'package:calsync/views/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import 'auth/calsync_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: "Calsync");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calsync',
      theme: CalsyncThemes.light,
      darkTheme: CalsyncThemes.dark,
      home: const CalSyncHomePage(title: 'Calsync'),
      onGenerateRoute: (RouteSettings routeParam) {
        // https://youtu.be/-XMexZCMCzU
        // Auto generate routes by using patterns
        final List<String> path = routeParam.name!.split('/');
        if (path[0] != '') {
          print("Path: $path");
          return null;
        }

        switch (path[1]) {
          case 'schedule':
            return MaterialPageRoute(
                builder: (BuildContext context) => SchedulePage());
          case 'day':
            return MaterialPageRoute(
                builder: (BuildContext context) => DayPage());
          case 'month':
            return MaterialPageRoute(
                builder: (BuildContext context) => MonthPage());
          case 'settings':
            return MaterialPageRoute(
                builder: (BuildContext context) => SettingsPage());
          default:
            return null;
        }
      },
    );
  }
}

class CalSyncHomePage extends StatefulWidget {
  const CalSyncHomePage({super.key, required this.title});

  final String title;

  @override
  State<CalSyncHomePage> createState() => _CalSyncHomePageState();
}

class _CalSyncHomePageState extends State<CalSyncHomePage> {
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

  // @override
  // void initState() {
  //   super.initState();
  //   initialization();
  // }
  //
  // void initialization() async {
  //   // This is where you can initialize the resources needed by your app while
  //   // the splash screen is displayed.  Remove the following example because
  //   // delaying the user experience is a bad design practice!
  //   // ignore_for_file: avoid_print
  //   print('ready in 3...');
  //   await Future.delayed(const Duration(seconds: 1));
  //   print('ready in 2...');
  //   await Future.delayed(const Duration(seconds: 1));
  //   print('ready in 1...');
  //   await Future.delayed(const Duration(seconds: 1));
  //   print('go!');
  //   FlutterNativeSplash.remove();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(children: [
          DrawerHeader(
            child: ListTile(
              title: Text("Drawer"),
              leading: Icon(Ionicons.cafe_outline),
              onTap: () {
                setState(() {
                  Navigator.popAndPushNamed(context, '/schedule');
                  // Navigator.pushNamed(context, '/schedule');
                });
              },
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    // builder methods always take context!
                    builder: (context) {
                      return const Text("dog");
                    },
                  ),
                );
              },
              child: const Text("data")),
        ]),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const Center(
            child: CalsyncAuth(),
          ),
          AboutListTile(
            icon: const Icon(Icons.info),
            applicationIcon: const FlutterLogo(),
            applicationName: 'Show About Examplee',
            applicationVersion: 'August 2019',
            applicationLegalese: '\u{a9} 2014 The Flutter Authors',
            aboutBoxChildren: aboutBoxChildren,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const SingleChildScrollView(
                    // child: AddEvent(),
                    child: Text("Hola"),
                  );
                },
                backgroundColor: Theme.of(context).disabledColor,
                enableDrag: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ));
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
