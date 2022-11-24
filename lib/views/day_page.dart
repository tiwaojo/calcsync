import 'package:calendar_sync/db/sqlite.dart';
import 'package:calendar_sync/models/event.dart' as events;
import 'package:calendar_sync/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:provider/provider.dart';

// Resources Used: https://youtu.be/hjB0vSjBMxw
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
        String? email = notifier.getCurrentUser?.email;
        print(notifier.getCurrentUser?.email);
        print(notifier.getEvents().toJson().values);
        List<Event>? gCalEvents = notifier.getEvents().items;
        if (gCalEvents != null) {
          return Container(
            child: Center(
              child: ListView.builder(
                  itemCount: gCalEvents.length,
                  itemBuilder: (context, index) {
                    // context  is context of position of widget in widget tree
                    // ListView.Builder only renders items that are within view
                    Event gCalEvent = gCalEvents[index];
                    String? title = gCalEvent.summary;
                    String subtitle = gCalEvent.start.toString();
                    EventsDatabase.instance.createItem(events.Event(
                        id: gCalEvent.id,
                        from: gCalEvent.start?.dateTime,
                        to: gCalEvent.end?.dateTime,
                        name: title,
                        description: gCalEvent.description,
                        email: email));
                    return ListTile(
                      title: Text(title!),
                      subtitle: Text("Event starts: $subtitle"),
                    );
                  }),
            ),
          );
        } else {
          return const SnackBar(content: Text("Could not load gCal Events"));
        }
      },
    );
  }
}
