import 'package:flutter/material.dart';
import 'package:calendar_sync/models/auth.dart';
import 'package:provider/provider.dart';

class DayPage extends StatefulWidget {
  const DayPage({Key? key}) : super(key: key);

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  @override
  Widget build(BuildContext context) {
    // final cal = Provider.of<CalsyncGoogleOAuth>(context);
    // return Text(cal.getCurrentUser?.email as String);
    return Consumer<CalsyncGoogleOAuth>(
        builder: (BuildContext context, notifier, child) {
      print(notifier.getCurrentUser?.email);
      print(notifier.getEvents().toJson().values);
      return Container(
        child: Center(
          child: notifier.getCurrentUser != null
              ? Text(notifier.getCurrentUser?.email as String)
              : Text("Lorm ipsum day"),
        ),
      );
    });
  }
}
