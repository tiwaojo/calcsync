// import 'package:calsync/models/auth.dart';
import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart'; //https://pub.dev/packages/extension_google_sign_in_as_googleapis_auth/example
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provides the `GoogleSignIn` class
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class CalsyncAuth extends StatefulWidget {
  const CalsyncAuth({Key? key}) : super(key: key);

  @override
  State<CalsyncAuth> createState() => _CalsyncAuthState();
}

class _CalsyncAuthState extends State<CalsyncAuth> {
  // final CalsyncGoogleOAuth _calsyncGoogleOAuth = CalsyncGoogleOAuth();
  GoogleSignInAccount? _currentUser;
  Events eventsList = Events(); // = "Empty Calendar List";
  CalendarList _calendarList = CalendarList();
  String userDetails = "user";
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[CalendarApi.calendarScope],
  ); // initialize at runtime

  @override
  void initState() {
    super.initState();
    print("init");
    // handleSignIn();
    signIn();
  }

  Future<void> signIn() async {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        if (_currentUser != null) {
          getCalendars();
        }
      });
    });
    await _googleSignIn.signInSilently();
  }

  Future<void> getCalendars() async {
    // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
    final auth.AuthClient? client = await _googleSignIn
        .authenticatedClient(); // a subscription to when the current user changes

    assert(client != null, 'Authenticated client missing!');

    final gCalAPI = CalendarApi(client!);
    _calendarList = await gCalAPI.calendarList.list();
    eventsList = await gCalAPI.events.list("primary");
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn().then((value) {
        _currentUser = value;
      });
    } catch (error) {
      print(error); // ignore: avoid_print
    }
  }

  Future handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          Text(_googleSignIn.currentUser!.email),
          ElevatedButton(
            onPressed: handleSignOut,
            child: const Text('SIGN OUT'),
          ),
          ElevatedButton(
            onPressed: getCalendars,
            child: const Text('REFRESH'),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          ElevatedButton(
            onPressed: handleSignIn,
            child: const Text('SIGN IN'),
          ),
        ],
      );
    }
  }

  List<Widget> printCalendars() {
    getCalendars();
    List<Text> calendarItems = [];
    // Start with the simpler items
    var it = _calendarList.items?.iterator;
    var e_it = eventsList.items?.iterator;
    // if (it != null) {
    //   while (it.moveNext()) {
    //     if (kDebugMode) {
    //       print(it.current.summary);
    //     }
    setState(() {
      if (e_it != null) {
        while (e_it.moveNext()) {
          if (e_it.current.summary == null) {
            continue;
          }
          var newItem = Text(e_it.current.summary as String);
          print(e_it.current.summary);
          calendarItems.add(newItem);
        }
      }
    });

    return calendarItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(onPressed: getCalendars, child: Text("List calendars")),
        buildCalendarList(),
        _buildBody(),
      ],
    );
  }

  Widget buildCalendarList() {
    if (_calendarList.items != null) {
      return SizedBox(
        width: 300.0,
        height: 300.0,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: printCalendars(),
        ),
      );
    } else {
      return Text("Calendar List not available");
    }
  }

  Image userImage() {
    return Image.network(
      _googleSignIn.currentUser!.photoUrl!,
      height: 200,
      cacheHeight: 200,
      cacheWidth: 400,
      filterQuality: FilterQuality.high,
      fit: BoxFit.contain,
      semanticLabel: _googleSignIn.currentUser!.displayName,
      width: 200,
      loadingBuilder: (context, child, progress) {
        return progress == null ? child : LinearProgressIndicator();
      },
    );
  }
}
