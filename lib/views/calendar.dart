import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../db/firestore_crud.dart';

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
    final Stream<QuerySnapshot> collectionReference =
        FirestoreCrud.readEvents("wasd@wasd.com");
    final DateTime today = DateTime.now();
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
        if (snapshot.hasData) {
          snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
            Map<String, dynamic> data =
                documentSnapshot.data()! as Map<String, dynamic>;
            from = data['from'].toDate();
            to = data['to'].toDate();
            isAllDay = data['isAllDay'];
            name = data['name'];
            id = documentSnapshot.id;
            meetings.add(
                Event(name, from, to, const Color(0xFF0F8644), isAllDay, id));
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
  }

  void calendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Event appointmentDetails = details.appointments![0];
      String timeDetails;
      String subjectText = appointmentDetails.eventName;
      String id = appointmentDetails.id;
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
                    },
                    child: const Text('Edit')),
                TextButton(
                    onPressed: () {
                      print("Edit Button Pressed");
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
      this.id);

  String id;

  String eventName;

  DateTime from;

  DateTime to;

  Color background;

  bool isAllDay;
}
