import 'package:calendar_sync/views/day_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    GoogleSignInAccount? _currentUser;

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
                  _prefs.setBool("navToHome", false); // Set onboarding to false
                  setState(() async {
                    await Navigator.popAndPushNamed(context, '/signin');
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
                  style: Theme.of(context).textTheme.headline5),
            ),
            Settings(),
            buildCenter(_currentUser, context, notifier),
          ],
        );
      },
    );
  }

  Widget buildCenter(GoogleSignInAccount? _currentUser, BuildContext context,
      CalsyncGoogleOAuth notifier) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 80,
        ),
        Text(
          notifier.getCurrentUser != null
              ? "Welcome \n${notifier.getCurrentUser?.displayName}"
              : "",
          style: Theme.of(context).textTheme.headline3,
        ),
        Container(
          child: notifier.getCurrentUser != null
              ? Image.network(
                  notifier.getCurrentUser?.photoUrl as String,
                  height: 100,
                  cacheHeight: 100,
                  cacheWidth: 100,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.contain,
                  semanticLabel: notifier.getCurrentUser!.displayName,
                  width: 200,
                  loadingBuilder: (context, child, progress) {
                    return progress == null ? child : LinearProgressIndicator();
                  },
                )
              : null,
        ),
        Text(
          notifier.getCurrentUser != null
              ? "${notifier.getCurrentUser?.email} is signed in"
              : "",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
