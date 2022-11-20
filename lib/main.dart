import 'package:calsync/themes/themes.dart';
import 'package:calsync/views/day_page.dart';
import 'package:calsync/views/month_page.dart';
import 'package:calsync/views/schedule_page.dart';
import 'package:calsync/views/settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: "Calsync");
  runApp(const MyApp());
}

int currentIndex = 0;

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
          // case 'schedule':
          //   return MaterialPageRoute(
          //       builder: (BuildContext context) => SchedulePage());
          // case 'day':
          //   return MaterialPageRoute(
          //       builder: (BuildContext context) => DayPage());
          // case 'month':
          //   return MaterialPageRoute(
          //       builder: (BuildContext context) => MonthPage());
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

  final routes = [
    SchedulePage(),
    DayPage(),
    MonthPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        child: Row(
          //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NavItem(
              icon: Icons.schedule_rounded,
              routeIndex: 0,
              btnLabel: "Schedule",
            ),
            NavItem(
              icon: Icons.calendar_view_day_rounded,
              routeIndex: 1,
              btnLabel: "Day",
            ),
            NavItem(
              icon: Icons.calendar_month_rounded,
              routeIndex: 2,
              btnLabel: "Month",
            ),
            NavItem(
                icon: Icons.settings_rounded,
                routeIndex: 3,
                btnLabel: "Settings"),
          ],
        ),
      ),
      body: routes[currentIndex],
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
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

  Column NavItem({
    required int routeIndex,
    required String btnLabel,
    required IconData icon,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              currentIndex = routeIndex;
              if (kDebugMode) {
                print("Route Index: $currentIndex");
              }
            });
          },
        ),
        Text(btnLabel),
      ],
    );
  }
}

class NavButton extends StatefulWidget {
  const NavButton(
      {Key? key,
      required this.icon,
      required this.routeIndex,
      required this.btnLabel})
      : super(key: key);

// final Icon selectedIcon;
  final IconData icon;
  final int routeIndex;
  final String btnLabel;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            widget.icon,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              currentIndex = widget.routeIndex;
              if (kDebugMode) {
                print("Route Index: $currentIndex");
              }
            });
          },
        ),
        Text(widget.btnLabel),
      ],
    );
  }
}
