import 'package:calendar_sync/views/day_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/calsync_auth.dart';
import '../models/auth.dart';
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
    return Consumer<CalsyncGoogleOAuth>(
      builder: (BuildContext context, notifier, child) {
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
              ElevatedButton(
                  onPressed: () async {
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    _prefs.setBool(
                        "navToHome", false); // Set onboarding to false

                    print(notifier.getCurrentUser);
                    notifier.handleSignOut(); // sign out user
                    print(notifier.getCurrentUser);
                    Navigator.pop(context);
                  },
                  child: Text("Signout")),
              dispPage ? DayPage() : Text("Could not display day page"),
              Settings(),
            ],
          ),
        );
      },
    );
  }
}
