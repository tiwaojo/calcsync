import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';

class EventsSync extends StatefulWidget {
  const EventsSync({Key? key}) : super(key: key);

  @override
  State<EventsSync> createState() => _EventsSyncState();
}

class _EventsSyncState extends State<EventsSync> {
  static const _scopes = [
    CalendarApi.calendarScope
  ]; // We have the read & write permission

  var _credentials;

  // if(Platform.isAndroid) {
  // _credentials = new ClientId("466724563377-lbfuln359gn1fkcnm41vk92fiqmvt825.apps.googleusercontent.com",  "");
  // } elseif(Platform.isIOS) {
  // _credentials = new ClientId(
  // "YOUR_CLIENT_ID_FOR_IOS_APP_RETRIEVED_FROM_Google_Console_Project_EARLIER",
  // "");
  // }

  // SHA1: F3:9A:83:5F:E2:7F:BC:B4:E1:77:A5:55:B5:5B:7D:FD:47:89:3D:4A
  // SHA256: CB:01:47:D2:3E:0C:D6:38:C3:81:39:1E:79:1D:5F:6A:EE:9E:BC:38:7B:1A:CA:5B:8E:B0:63:13:2D:F6:48:16

  void getEvents() {
    setState(() {
      //  TODO: implement method of gathering events from gcal
    });
  }

  void sendEvents() {
    setState(() {
      //  TODO: implement method of sending custom events to gcal
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
