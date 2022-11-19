import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
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
  // FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignInAccount? _currentUser;
  String calList = "Empty Calendar List";
  String userDetails = "user";
  late final GoogleSignIn _googleSignIn; // initialize at runtime

  // String getClientId() {
  //   final response = rootBundle.loadString('assets/client_secret.json')
  //       as String; // load client_secret.json
  //   Map<String, dynamic> clientId =
  //       jsonDecode(response); // Get the client id from json object
  //   print(clientId);
  //   return clientId["client_id"].toString();
  // }

  @override
  void initState() {
    super.initState();

    _googleSignIn = GoogleSignIn(
      scopes: <String>[CalendarApi.calendarScope],
      serverClientId:
          "466724563377-lbfuln359gn1fkcnm41vk92fiqmvt825.apps.googleusercontent.com", // getClientId(), iz7M@HY5$r9fiLP?
    );

    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        print("Not signed in");
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

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        userDetails = _googleSignIn.currentUser?.email as String;
      });
    } catch (error) {
      print(error); // ignore: avoid_print
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void listCalendars() {
    getCalendars();
  }

  void test() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: _handleSignIn, child: Text("Sign in to google")),
        ElevatedButton(onPressed: listCalendars, child: Text("List calendars")),
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => add_events()));
            },
            child: Text("Add Event (test)")),
        Text(calList),
        Text(userDetails)
      ],
    );
  }
}
