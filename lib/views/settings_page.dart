import 'package:calendar_sync/views/day_page.dart';
import 'package:flutter/material.dart';

import '../auth/calsync_auth.dart';
import '../settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool dispPage = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CalsyncAuth(),
          ElevatedButton(
            onPressed: () {
              dispPage = true;
              setState(() {
                print("Render Page: $dispPage");
              });
            },
            child: const Text("Sync"),
          ),
          dispPage ? DayPage() : Text("Could not display day page"),
          Settings(),
        ],
      ),
    );
  }
}
