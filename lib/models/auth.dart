import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';

/// Provides the `GoogleSignIn` class
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class CalsyncGoogleOAuth {
  GoogleSignInAccount? _currentUser;
  String calList = "Empty Calendar List";
  static GoogleSignIn _googleSignIn = GoogleSignIn();

  // CalsyncGoogleOAuth() {
  //   signIn();
  // }

  GoogleSignInAccount? get currentUser => _currentUser;

  Future signIn() async {
    _googleSignIn = GoogleSignIn(
      scopes: <String>[CalendarApi.calendarScope],
      serverClientId: Platform.isAndroid
          ? "466724563377-lbfuln359gn1fkcnm41vk92fiqmvt825.apps.googleusercontent.com"
          : "466724563377-na4725bb0fmgl93mhrqj60brcbpehqkg.apps.googleusercontent.com", // getClientId(),
    );
    // return _currentUser;
  }

  Future<void> changeUser() async {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // setState(() {
      _currentUser = account;
      // });
      if (_currentUser != null) {
        if (kDebugMode) {
          print("Not signed in");
        }
        getCalendars();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> getCalendars() async {
    // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
    final auth.AuthClient? client = await _googleSignIn
        .authenticatedClient(); // a subscription to when the current user changes

    assert(client != null, 'Authenticated client missing!');

    var gCalAPI = CalendarApi(client!);
    calList = (await gCalAPI.calendarList.list(maxResults: 5))
        .items
        ?.first
        .description as String;
    // setState(() {
    if (kDebugMode) {
      // calList = calendarList as String;
      print(calList);
    }
    // });
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      // setState(() {
      _currentUser = _googleSignIn.currentUser?.email as GoogleSignInAccount?;
      // });
    } catch (error) {
      print(error); // ignore: avoid_print
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();
}
