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
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // CalsyncAuth(),
            ElevatedButton(
              onPressed: () {
                dispPage = true;
                setState(() {
                  print("Render Page: $dispPage");
                });
              },
              child: Text(
                "Sync",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (notifier.getCurrentUser != null) {
                    // if the current user is signed in sign them out and navigate to the sign in page
                    SharedPreferences _prefs =
                        await SharedPreferences.getInstance();
                    _prefs.setBool(
                        "navToHome", false); // Set onboarding to false
                    setState(() {
                      Navigator.popAndPushNamed(context, '/signin');
                      notifier.handleSignOut(); // sign out user
                    });
                  } else {
                    setState(() {
                      Navigator.popAndPushNamed(context, '/signin');
                      // notifier.signIn(); // sign out user
                    });
                  }
                },
                child: Text(
                    notifier.getCurrentUser != null ? "Signout" : "Signin",
                    style: Theme.of(context).textTheme.headline5)),
            // dispPage ? DayPage() : Text("Could not display day page"),
            Settings(),
          ],
        );
      },
    );
  }
}
