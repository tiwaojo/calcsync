import 'dart:convert';
import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Provides the `GoogleSignIn` class
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class CalsyncGoogleOAuth extends ChangeNotifier {
  // Resource used: https://pub.dev/packages/extension_google_sign_in_as_googleapis_auth
  // flutter.dev/go/google-apis
  // https://youtu.be/z4MsuZiEezY
  // https://youtu.be/E5WgU6ERZzA

  // CalsyncGoogleOAuth._(); //private constructor
  GoogleSignInAccount? _currentUser;
  static Events eventsList = Events();
  static CalendarList _calendarList = CalendarList();
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[CalendarApi.calendarScope],
    // serverClientId: getClientId().toString()
  ); // initialize at runtime;

  CalsyncGoogleOAuth() {
    // _getClientId().then((value) => print(value));
    signIn();
  }

// TODO: To complete the usage of internet resources project requirement
  Future<String> getClientId() async {
    final response = await rootBundle
        .loadString('assets/client_secret-Web.json'); // load client_secret.json
    Map<String, dynamic> platform =
        jsonDecode(response); // Get the client id from json object

    final clientId = platform["web"];
    // print(clientId);
    return clientId['client_id'];
  }

  GoogleSignInAccount? get getCurrentUser =>
      _currentUser; // Get Current User Signin
  notifyListeners();

  void signIn() async {
    // googleSignIn.serverClientId = _getClientId().toString;
    // _getClientId().then((value) => clientId=value);
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      // setState(() {
      _currentUser = account;
      // _currentUser ?? getCalendars();

      if (_currentUser != null) {
        getCalendars();
      }
      // });
    }); // https://youtu.be/Q00Foa8CiDk
    googleSignIn.signInSilently();
    if (await googleSignIn.isSignedIn()) {
      notifyListeners();
    } else {
      handleSignIn();
    }
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

  Events getEvents() {
    return eventsList;
  }

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

  Future<void> handleSignOut() async => await googleSignIn.disconnect();
}
