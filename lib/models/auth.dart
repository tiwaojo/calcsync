import 'dart:convert';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Provides the `GoogleSignIn` class
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class CalsyncGoogleOAuth {
  // CalsyncGoogleOAuth._(); //private constructor
  GoogleSignInAccount? _currentUser;
  static String calList = "Empty Calendar List";
  late final GoogleSignIn googleSignIn;

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
    _currentUser = value;
  } // CalsyncGoogleOAuth() {
  //   getClientId().then((value) => print(value));
  //   signIn();
  // }

  GoogleSignInAccount? get getCurrentUser => _currentUser;

  void signIn() {
    // _getClientId().then((value) => print(value));
    googleSignIn = GoogleSignIn(
        scopes: <String>[CalendarApi.calendarScope],
        clientId:
            "466724563377-5jl8rqj52qt73iqukrlfoeqvk7gmeman.apps.googleusercontent.com",
        serverClientId:
            //Platform.isAndroid ?
            "466724563377-5jl8rqj52qt73iqukrlfoeqvk7gmeman.apps.googleusercontent.com"
        //  : "466724563377-na4725bb0fmgl93mhrqj60brcbpehqkg.apps.googleusercontent.com", // getClientId(),
        );
    // changeUser();
    // return _currentUser;
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

  Future<void> handleSignIn() async {
    try {
      await googleSignIn.signIn();
      // setState(() {
      _currentUser = googleSignIn.currentUser;
      // });
    } catch (error) {
      print(error); // ignore: avoid_print
    }
  }

  Future handleSignOut() => googleSignIn.disconnect();
}
