import 'package:calsync/models/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CalsyncAuth extends StatefulWidget {
  const CalsyncAuth({Key? key}) : super(key: key);

  @override
  State<CalsyncAuth> createState() => _CalsyncAuthState();
}

class _CalsyncAuthState extends State<CalsyncAuth> {
  final CalsyncGoogleOAuth _calsyncGoogleOAuth = new CalsyncGoogleOAuth();

  @override
  void initState() {
    super.initState();
    _calsyncGoogleOAuth.signIn();
    // _calsyncGoogleOAuth.handleSignIn();
    // _calsyncGoogleOAuth.changeUser();
    // _googleSignIn = GoogleSignIn(
    //   scopes: <String>[CalendarApi.calendarScope],
    //   serverClientId: Platform.isAndroid
    //       ? "466724563377-lbfuln359gn1fkcnm41vk92fiqmvt825.apps.googleusercontent.com"
    //       : "466724563377-na4725bb0fmgl93mhrqj60brcbpehqkg.apps.googleusercontent.com", // getClientId(),
    // );
    //
    // _googleSignIn.onCurrentUserChanged
    //     .listen((GoogleSignInAccount? account) async {
    //   setState(() {
    //     _currentUser = account;
    //   });
    //   if (_currentUser != null) {
    //     if (kDebugMode) {
    //       print("Not signed in");
    //     }
    //     getCalendars();
    //   }
    // });
    // _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Column(
        children: [
          _calsyncGoogleOAuth.getCurrentUser != null
              ? userImage()
              : Text("lorem ipsum..."),
          ElevatedButton(
              onPressed: _calsyncGoogleOAuth.handleSignIn,
              child: Text("Sign in to google")),
          ElevatedButton(
              onPressed: _calsyncGoogleOAuth.getCalendars,
              child: Text("List calendars")),
          Text(CalsyncGoogleOAuth.calList),
        ],
      ),
    );
  }

  Image userImage() {
    return Image.network(
      _calsyncGoogleOAuth.getCurrentUser!.photoUrl.toString(),
      height: 200,
      cacheHeight: 200,
      cacheWidth: 400,
      filterQuality: FilterQuality.high,
      fit: BoxFit.contain,
      semanticLabel: _calsyncGoogleOAuth.getCurrentUser!.displayName,
      width: 200,
      loadingBuilder: (context, child, progress) {
        return progress == null ? child : LinearProgressIndicator();
      },
    );
  }
}
