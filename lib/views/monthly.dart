import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/cloudsearch/v1.dart';
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
    return Scaffold(
        body: SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(_getDataSource()),
      // by default the month appointment display mode set as Indicator, we can
      // change the display mode as appointment using the appointment display
      // mode property
      monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    ));
  }

  List<Event> _getDataSource() {
    final List<Event> meetings = <Event>[];
    final Stream<QuerySnapshot> collectionReference =
        FirestoreCrud.readEvents("dwad@wadwa.com");
    final DateTime today = DateTime.now();
    // StreamBuilder(
    //     stream: collectionReference,
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.hasData) {
    //         DateTime from = DateTime(today.year, today.month, today.day, 9);
    //         DateTime to = from.add(const Duration(hours: 2));
    //         bool isAllDay = false;
    //         String name = "Null";
    //         snapshot.data!.docs.map((e) {
    //           from = e['from'];
    //           to = e['to'];
    //           isAllDay = e['isAllDay'];
    //           name = e['name'];
    //         });
    //         meetings
    //             .add(Event(name, from, to, const Color(0xFF0F8644), isAllDay));
    //       }
    //     });

    return meetings;
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
  Event(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;

  DateTime from;

  DateTime to;

  Color background;

  bool isAllDay;
}
