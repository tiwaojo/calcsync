import 'package:calendar_sync/add_events.dart';
import 'package:calendar_sync/views/month_page.dart';
import 'package:calendar_sync/views/settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

int currentIndex = 0;

class CalSyncHomePage extends StatefulWidget {
  final bool continueToApp;
  final String title;

  const CalSyncHomePage(
      {Key? key, this.continueToApp = false, this.title = "Calsync"})
      : super(key: key);

  @override
  State<CalSyncHomePage> createState() => _CalSyncHomePageState();
}

class _CalSyncHomePageState extends State<CalSyncHomePage> {
  @override
  void initState() {
    super.initState();
  }

  final routes = [
    // SchedulePage(),
    // DayPage(),
    MonthPage(),
    SettingsPage(),
  ];
  bool modalOpen = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              // TODO
            },
            icon: Icon(Icons.ballot),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 15.0,
        elevation: 6,
        child: Row(
          //children inside bottom appbar
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // NavItem(
            //   icon: Icons.schedule_rounded,
            //   routeIndex: 0,
            //   btnLabel: "Schedule",
            // ),
            // NavItem(
            //   icon: Icons.calendar_view_day_rounded,
            //   routeIndex: 1,
            //   btnLabel: "Day",
            // ),
            NavItem(
              icon: Icons.calendar_month_rounded,
              routeIndex: 0,
              btnLabel: "Month",
            ),
            NavItem(
                icon: Icons.settings_rounded,
                routeIndex: 1,
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
          if (modalOpen == false) {
            modalOpen = true;
            setState(() {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SingleChildScrollView(
                      // reverse: true,
                      child: AddEvent(),
                    ),
                  );
                },
                backgroundColor: Theme.of(context).disabledColor,
                enableDrag: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
              );
              if (modalOpen == true) {
                modalOpen = false;
              }
            });
          }
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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          bottom: 50,
          child: IconButton(
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
        ),
        Positioned(bottom: 50, child: Text(widget.btnLabel)),
      ],
    );
  }
}
