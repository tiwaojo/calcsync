import 'dart:convert';
import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Provides the `GoogleSignIn` class
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class CalsyncGoogleOAuth {
  // Resource used: https://pub.dev/packages/extension_google_sign_in_as_googleapis_auth
  // flutter.dev/go/google-apis
  // https://youtu.be/z4MsuZiEezY
  // https://youtu.be/E5WgU6ERZzA

  // CalsyncGoogleOAuth._(); //private constructor
  GoogleSignInAccount? _currentUser;
  Events eventsList = Events();
  CalendarList _calendarList = CalendarList();
  late final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[CalendarApi.calendarScope],
    serverClientId: Platform.isAndroid
        ? "209176434525-7c14rp97kdg9r5s5l0q48i9q0u9bieh1.apps.googleusercontent.com"
        : "209176434525-jvffc44tf0qjocbrbjrmbib4mcdaipf0.apps.googleusercontent.com", // getClientId(),
  ); // initialize at runtime;

  CalsyncGoogleOAuth() {
    // _getClientId().then((value) => print(value));
    signIn();
  }

// TODO: To complete the usage of internet resources project requirement
  Future<String> _getClientId() async {
    final response = await rootBundle
        .loadString('assets/client_secret.json'); // load client_secret.json
    Map<String, dynamic> clientId =
        jsonDecode(response); // Get the client id from json object
    // print(clientId);
    return clientId["client_id"];
  }

  set currentUser(GoogleSignInAccount value) {
    _currentUser = value; // Set Current User Signin
  }

  GoogleSignInAccount? get getCurrentUser =>
      _currentUser; // Get Current User Signin

  void signIn() {
    // _getClientId().then((value) => print(value));
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      // setState(() {
      _currentUser = account;
      _currentUser ?? getCalendars();

      // });
    }); // https://youtu.be/Q00Foa8CiDk
    googleSignIn.signInSilently();
  }

  // void changeUser() {
  //   _googleSignIn.onCurrentUserChanged
  //       .listen((GoogleSignInAccount? account) async {
  //     setState(() {
  //       _currentUser = account;
  //     });
  //     if (_currentUser != null) {
  //       if (kDebugMode) {
  //         print("Not signed in");
  //       }
  //       getCalendars();
  //     }
  //   });
  //   _googleSignIn.signInSilently();
  //   // getCalendars();
  // }

  Future<void> getCalendars() async {
    // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
    final auth.AuthClient? client = await googleSignIn
        .authenticatedClient(); // a subscription to when the current user changes

    assert(client != null, 'Authenticated client missing!');

    final gCalAPI = CalendarApi(client!);
    _calendarList = await gCalAPI.calendarList.list();
    eventsList = await gCalAPI.events.list("primary");
  }

  Future<void> handleSignIn() async {
    try {
      await googleSignIn.signIn().then((value) {
        _currentUser = value;
      });
    } catch (error) {
      print(error); // ignore: avoid_print
    }
  }

  Future handleSignOut() => googleSignIn.disconnect();
}
