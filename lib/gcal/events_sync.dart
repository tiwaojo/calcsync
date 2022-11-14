import 'dart:html';

import 'package:flutter/material.dart';
import "package:googleapis_auth/auth_io.dart";
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

  if

  (

  Platform

      .

  ) {
  _credentials = new ClientId(
  "466724563377-lbfuln359gn1fkcnm41vk92fiqmvt825.apps.googleusercontent.com",
  "");
  } elseif

  (

  Platform.isIOS

  ) {
  _credentials = new ClientId(
  "YOUR_CLIENT_ID_FOR_IOS_APP_RETRIEVED_FROM_Google_Console_Project_EARLIER",
  "");
  }

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
