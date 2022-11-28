import 'package:calendar_sync/db/sqlite.dart';
import 'package:calendar_sync/models/auth.dart';
import 'package:calendar_sync/models/event.dart' as events;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Resources Used: https://youtu.be/hjB0vSjBMxw
class DayPage extends StatefulWidget {
  const DayPage({Key? key}) : super(key: key);

  @override
  State<DayPage> createState() => _DayPageState();
}

class _DayPageState extends State<DayPage> {
  late ScrollController listScrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<CalsyncGoogleOAuth>(
      builder: (BuildContext context, notifier, child) {
        String? email = notifier.getCurrentUser?.email;
        print(notifier.getCurrentUser?.email);
        print(notifier.getEvents().toJson().values);
        List<Event>? gCalEvents = notifier.getEvents().items;
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: gCalEvents != null
                ? ListView.builder(
                    //auto keep alive is false to prevent children from keeping their state
                    addAutomaticKeepAlives: false,
                    dragStartBehavior: DragStartBehavior.start,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: BouncingScrollPhysics(),
                    cacheExtent: 9,
                    // controller: listScrollController,
                    itemCount: gCalEvents?.length,
                    itemBuilder: (context, index) {
                      // context  is context of position of widget in widget tree
                      // ListView.Builder only renders items that are within view
                      // if (gCalEvents != null) {
                      Event gCalEvent = gCalEvents[index];
                      String title = gCalEvent.summary.toString();
                      String subtitle = "N/A";
                      if (gCalEvent.start?.date != null) {
                        subtitle = DateFormat("EEE., MMM d, yyyy")
                            .format(gCalEvent.start?.date as DateTime)
                            .toString();
                      }
                      String description = gCalEvent.description.toString();
                      EventsDatabase.instance.createItem(events.Event(
                          id: gCalEvent.id,
                          from: gCalEvent.start?.dateTime,
                          to: gCalEvent.end?.dateTime,
                          name: title,
                          description: description,
                          email: email));
                      print(events.Event);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        margin: EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(
                              width: 2, color: Theme.of(context).focusColor),
                        ),
                        child: ListTile(
                          visualDensity: VisualDensity.comfortable,
                          title: Text(
                            title,
                            style:
                                Theme.of(context).textTheme.headline6?.copyWith(
                                      color: Color(0xFFFFFFFF),
                                    ),
                          ),
                          subtitle: Text("Event starts: $subtitle",
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  ?.copyWith(
                                    color: Color(0xFFFFFFFF),
                                  )),
                        ),
                      );
                      // }
                    })
                : Text("Please sign in to view Google Calendars here."),
          ),
        );
      },
    );
  }
}
