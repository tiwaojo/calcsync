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
              DayPage();
            },
            child: const Text("Sync"),
          ),
          Settings(),
        ],
      ),
    );
  }
}
