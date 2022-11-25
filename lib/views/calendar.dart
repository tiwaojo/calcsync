import 'package:calendar_sync/models/event.dart' as events;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../db/firestore_crud.dart';
import '../db/sqlite.dart';
import '../edit_events.dart';
import '../models/auth.dart';

/// The hove page which hosts the calendar
class MonthView extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const MonthView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    return Consumer<CalsyncGoogleOAuth>(
        builder: (BuildContext context, notifier, child) {
      String email = "";
      if (notifier.currentUser != null) {
        email = notifier.currentUser?.email as String;
      }
      refreshMeetings(email);
      final Stream<QuerySnapshot> collectionReference =
          FirestoreCrud.readEvents(email);
      return Scaffold(
          body: StreamBuilder(
        stream: collectionReference,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<Event> meetings = <Event>[];
          DateTime from = DateTime(today.year, today.month, today.day, 9);
          DateTime to = from.add(const Duration(hours: 2));
          bool isAllDay = false;
          String name = "Null";
          String id = "Null";
          String description = "Null";
          if (snapshot.hasData) {
            snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              Map<String, dynamic> data =
                  documentSnapshot.data()! as Map<String, dynamic>;
              from = data['from'].toDate();
              to = data['to'].toDate();
              isAllDay = data['isAllDay'];
              name = data['name'];
              id = documentSnapshot.id;
              description = data['description'];
              meetings.add(Event(name, from, to, const Color(0xFF0F8644),
                  isAllDay, id, description, "firebase"));
            }).toList();
          }

          return SfCalendar(
            view: CalendarView.month,
            dataSource: EventDataSource(meetings),
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.month
            ],
            // by default the month appointment display mode set as Indicator, we can
            // change the display mode as appointment using the appointment display
            // mode property
            monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showAgenda: true),
            onTap: calendarTapped,
          );
        },
      ));
    });
  }

  Future<void> refreshMeetings(String email) async {
    final DateTime today = DateTime.now();
    DateTime from = DateTime(today.year, today.month, today.day, 9);
    DateTime to = from.add(const Duration(hours: 2));
    String name = "Null";
    String id = "Null";
    String description = "Null";
    var eventsList = await EventsDatabase.instance.getItems();
    for (events.Event value in eventsList) {
      String valueName = value.name ?? name;
      DateTime valueFrom = value.from ?? from;
      DateTime valueTo = value.to ?? to;
      String valueId = value.id ?? id;
      String valueDescription = value.description ?? description;
      FirestoreCrud.addIfNotExistsEvent(
          id: valueId,
          to: valueTo,
          from: valueFrom,
          isAllDay: false,
          name: valueName,
          description: valueDescription,
          email: email);
    }
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Event appointmentDetails = details.appointments![0];
      String timeDetails;
      String subjectText = appointmentDetails.eventName;
      String id = appointmentDetails.id;
      String descriptionText = appointmentDetails.description;
      String dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.from)
          .toString();
      String startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.from).toString();
      String endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.to).toString();
      if (appointmentDetails.isAllDay) {
        timeDetails = 'All day';
      } else {
        timeDetails = '$startTimeText - $endTimeText';
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(subjectText),
              content: SizedBox(
                height: 80,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          descriptionText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          dateText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const <Widget>[
                        Text(''),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(timeDetails,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close')),
                TextButton(
                    onPressed: () {
                      print("Edit Button Pressed: $id");

                      setState(() {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: EditEvent(
                                    id: id,
                                    description: appointmentDetails.description,
                                    name: appointmentDetails.eventName,
                                    from: appointmentDetails.from,
                                    to: appointmentDetails.to,
                                    source: appointmentDetails.source),
                                //child: Text("Hola"),
                              );
                            },
                            backgroundColor: Theme.of(context).disabledColor,
                            enableDrag: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ));
                      });
                    },
                    child: const Text('Edit')),
                TextButton(
                    onPressed: () {
                      print("Delete Button Pressed: $id");
                      if (appointmentDetails.source == "firebase") {
                        FirestoreCrud.deleteEvent(id: id);
                      }
                      if (appointmentDetails.source == "local") {
                        EventsDatabase.instance.deleteItem(id);
                      }
                    },
                    child: const Text('Delete')),
              ],
            );
          });
    }
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    print("FINAL:${source.length}");
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getEventData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getEventData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getEventData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getEventData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getEventData(index).isAllDay;
  }

  Event _getEventData(int index) {
    final dynamic meeting = appointments![index];
    late final Event meetingData;
    if (meeting is Event) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Event {
  Event(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.id, this.description, this.source);

  String id;

  String eventName;

  String description;

  DateTime from;

  DateTime to;

  Color background;

  bool isAllDay;

  String source;
}
