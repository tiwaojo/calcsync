import 'package:calsync/models/auth.dart';
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
  final CalsyncGoogleOAuth _calsyncGoogleOAuth = CalsyncGoogleOAuth();
  GoogleSignInAccount? _currentUser;
  String calList = "Empty Calendar List";
  String userDetails = "user";
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[CalendarApi.calendarReadonlyScope],
      serverClientId:
          // Platform.isAndroid ?
          "466724563377-5jl8rqj52qt73iqukrlfoeqvk7gmeman.apps.googleusercontent.com"
      // : "466724563377-na4725bb0fmgl93mhrqj60brcbpehqkg.apps.googleusercontent.com", // getClientId(),
      ); // initialize at runtime
  @override
  void initState() {
    super.initState();
    print("init");
    //   _calsyncGoogleOAuth.signIn();
    //   changeUser();
    //   // _calsyncGoogleOAuth.handleSignIn();
    //   //
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        if (kDebugMode) {
          print("signed in");
          print(_currentUser);
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
    setState(() {
      if (kDebugMode) {
        // calList = calendarList as String;
        print(calList);
      }
    });
  }

  void changeUser() {
    _calsyncGoogleOAuth.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      setState(() {
        _calsyncGoogleOAuth.currentUser = account!;
      });
      if (_calsyncGoogleOAuth.getCurrentUser != null) {
        if (kDebugMode) {
          print("Not signed in");
        }
        _calsyncGoogleOAuth.getCalendars();
      }
    });
    _calsyncGoogleOAuth.googleSignIn.signInSilently();
    // getCalendars();
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error); // ignore: avoid_print
    } finally {
      getCalendars();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          // _googleSignIn != null ? userImage() : Text("lorem ipsum..."),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  // _calsyncGoogleOAuth.handleSignIn();
                  handleSignIn();
                  print(_googleSignIn.currentUser);
                });
              },
              child: Text("Sign in to google")),
          ElevatedButton(
              onPressed: _calsyncGoogleOAuth.getCalendars,
              child: Text("List calendars")),
          Text(CalsyncGoogleOAuth.calList),
          _buildBody(),
        ],
      ),
    );
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
