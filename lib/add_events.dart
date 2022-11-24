import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../db/firestore_crud.dart';
import 'models/auth.dart';

// class add_events extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: " Test",
//       home: addEvent(),
//     );
//   }
// }

class AddEvent extends StatefulWidget {
  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String title = '';
  String description = '';
  DateTime start_day = DateTime.now();
  TimeOfDay start_time = TimeOfDay.now();
  DateTime end_day = DateTime.now();
  TimeOfDay end_time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<CalsyncGoogleOAuth>(
        builder: (BuildContext context, notifier, child) {
      String email = "";
      if (notifier.currentUser != null) {
        email = notifier.currentUser?.email as String;
      }
      return Container(
        child: Column(children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Title'),
            onChanged: (value) => setState(() => title = value),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Description'),
            onChanged: (value) => setState(() => description = value),
          ),
          Text("Select the start time of your event"),
          ListTile(
            title: Text(
                "Date: ${start_day.year}, ${start_day.month}, ${start_day.day}"),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              _pickStartDate(context);
            },
          ),
          ListTile(
            title: Text("Time: ${start_time.hour}:${start_time.minute}"),
            trailing: Icon(Icons.access_time),
            onTap: () {
              _pickStartTime(context);
            },
          ),
          Text("Select the end time of your event"),
          ListTile(
            title:
                Text("Date: ${end_day.year}, ${end_day.month}, ${end_day.day}"),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              _pickEndDate(context);
            },
          ),
          ListTile(
            title: Text("Time: ${end_time.hour}:${end_time.minute}"),
            trailing: Icon(Icons.access_time),
            onTap: () {
              _pickEndTime(context);
            },
          ),
          ElevatedButton(
              onPressed: () {
                create_event(title, description, start_day, start_time, end_day,
                    end_time, email);
              },
              child: Text("Create Event")),
        ]),
      );
    });
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (selectedDate != null) {
      setState(() {
        start_day = selectedDate;
      });
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: start_day,
        firstDate: start_day,
        lastDate: DateTime(2100));
    if (selectedDate != null) {
      setState(() {
        end_day = selectedDate;
      });
    }
  }

  Future<void> _pickStartTime(BuildContext context) async {
    final TimeOfDay? t =
        await showTimePicker(context: context, initialTime: start_time);
    if (t != null) {
      setState(() {
        start_time = t;
      });
    }
  }

  Future<void> _pickEndTime(BuildContext context) async {
    final TimeOfDay? t =
        await showTimePicker(context: context, initialTime: start_time);
    if (t != null) {
      setState(() {
        end_time = t;
      });
    }
  }

  void create_event(
      String title,
      String discription,
      DateTime start_day,
      TimeOfDay start_time,
      DateTime end_day,
      TimeOfDay end_time,
      String email) {
    DateTime to = DateTime(start_day.year, start_day.month, start_day.day,
        start_time.hour, start_time.minute);
    DateTime from = DateTime(end_day.year, end_day.month, end_day.day,
        end_time.hour, end_time.minute);
    // new_event.name = title;
    // new_event.description = discription;
    // new_event.from = start_day;
    // new_event.to = end_day;

    FirestoreCrud.addEvent(
        to: to,
        from: from,
        isAllDay: false,
        name: title,
        description: discription,
        email: email);

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Created"),
                content: Text("$title - $discription \n"
                    " From Date: ${start_day.year}, ${start_day.month}, ${start_day.day} Time: ${start_time.hour}:${start_time.minute} \n "
                    " To Date: ${end_day.year}, ${end_day.month}, ${end_day.day} Time: ${end_time.hour}:${end_time.minute}"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"))
                ]));
  }
}
