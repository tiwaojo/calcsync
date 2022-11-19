import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
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
    return CurvedNavigationBar(
      index: currentIndex,
      key: _bottomNavigationKey,
      letIndexChange: (index) => true,
      items: [
        CurvedNavButton(
          icon: Icon(Ionicons.cafe_outline),
          routeIndex: 0,
        ),
        CurvedNavButton(
          icon: Icon(Ionicons.calendar_number_sharp),
          routeIndex: 1,
        ),
        CurvedNavButton(
          icon: Icon(Ionicons.calendar_clear_outline),
          routeIndex: 2,
        ),
      ],
      backgroundColor: Colors.amberAccent.shade700,
      animationDuration: const Duration(
        milliseconds: 200,
      ),
      animationCurve: Curves.easeInOut,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
        // final _pageController = PageController();
        // _pageController.jumpToPage(currentIndex);
      },
    );
  }
}

class CurvedNavButton extends StatefulWidget {
  const CurvedNavButton({
    Key? key,
    // this.selectedIcon,
    required this.icon,
    required this.routeIndex,
  }) : super(key: key);

  // final Icon selectedIcon;
  final Icon icon;
  final int routeIndex;

  @override
  State<CurvedNavButton> createState() => _CurvedNavButtonState();
}

class _CurvedNavButtonState extends State<CurvedNavButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      // selectedIcon: selectedIcon ?? icon,
      onPressed: () {
        // setState(() {
        final CurvedNavigationBarState? navBarState =
            _bottomNavigationKey.currentState;
        navBarState?.setPage(widget.routeIndex);

        // });
        // Navigator.pushNamed(context, '/schedule');
      },
      icon: widget.icon,
    );
  }
}

class NavButton extends StatefulWidget {
  const NavButton({Key? key}) : super(key: key);

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text("text"));
  }
}
