import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

int currentIndex = 0;

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int idx = 0;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 5,
      child: Row(
        //children inside bottom appbar
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[
          NavButton(
            icon: Icons.schedule_rounded,
            routeIndex: 0,
            btnLabel: "Schedule",
          ),
          NavButton(
            icon: Icons.calendar_view_day_rounded,
            routeIndex: 1,
            btnLabel: "Day",
          ),
          NavButton(
            icon: Icons.calendar_month_rounded,
            routeIndex: 2,
            btnLabel: "Month",
          ),
          NavButton(
            icon: Icons.settings_rounded,
            routeIndex: 3,
            btnLabel: "Settings",
          ),
        ],
      ),
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
