// import 'package:calsync/models/auth.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart'; //https://pub.dev/packages/extension_google_sign_in_as_googleapis_auth/example
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:calsync/add_events.dart';

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
  late Events eventsList; // = "Empty Calendar List";
  CalendarList _calendarList = CalendarList();
  String userDetails = "user";
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[CalendarApi.calendarScope],
      serverClientId:
          Platform.isAndroid ?
          "209176434525-7c14rp97kdg9r5s5l0q48i9q0u9bieh1.apps.googleusercontent.com"
      : "209176434525-jvffc44tf0qjocbrbjrmbib4mcdaipf0.apps.googleusercontent.com", // getClientId(),
      ); // initialize at runtime
  @override
  void initState() {
    super.initState();
    print("init");
    // handleSignIn();
    signIn();
  }

  void signIn() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently().then((value) {
      print(value);
      _currentUser = value;
    });
  }

  Future<void> getCalendars() async {
    // Retrieve an [auth.AuthClient] from the current [GoogleSignIn] instance.
    final auth.AuthClient? client = await _googleSignIn
        .authenticatedClient(); // a subscription to when the current user changes

    assert(client != null, 'Authenticated client missing!');

    final gCalAPI = CalendarApi(client!);
    _calendarList = await gCalAPI.calendarList.list();
    var it = _calendarList.items?.iterator;
    if (it != null) {
      while (it.moveNext()) {
        if (kDebugMode) {
          print("Summary of calendar: ${it.current.summary}");
        }
      }
    }
    // eventsList = await gCalAPI.events
    //     .list(maxResults: 5, orderBy: "startTime", alwaysIncludeEmail: true);
    // setState(() {
    //   var it = _calendarList.items?.iterator;
    //     while (it!.moveNext()) {
    //       if (kDebugMode) {
    //         print(it.current.summary);
    //         // Text(it.current.summary as String);
    //         // calList = calendarList as String;
    //         // print(calList);
    //       }
    //     }
    // });
  }

  // void changeUser() {
  //   _calsyncGoogleOAuth.googleSignIn.onCurrentUserChanged
  //       .listen((GoogleSignInAccount? account) async {
  //     setState(() {
  //       _calsyncGoogleOAuth.currentUser = account!;
  //     });
  //     if (_calsyncGoogleOAuth.getCurrentUser != null) {
  //       if (kDebugMode) {
  //         print("Not signed in");
  //       }
  //       _calsyncGoogleOAuth.getCalendars();
  //     }
  //   });
  //   _calsyncGoogleOAuth.googleSignIn.signInSilently();
  //   // getCalendars();
  // }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn().then((value) {
        _currentUser = value;
      });
    } catch (error) {
      print(error); // ignore: avoid_print
    } finally {
      getCalendars(); //
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

    var it = _calendarList.items?.iterator;
    if (it != null) {
      while (it.moveNext()) {
        if (kDebugMode) {
          print(it.current.summary);
        }
        setState(() {
          var newItem = Text(it.current.summary as String);
          calendarItems.add(newItem);
        });
      }
    }
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
