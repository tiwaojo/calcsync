import 'package:calendar_sync/db/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../db/firestore_crud.dart';
import '../db/firestore.dart';
import '../models/event.dart';
import 'models/auth.dart';

class EditEvent extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final DateTime from;
  final DateTime to;
  final String source;
  const EditEvent(
      {Key? key,
      required this.id,
      required this.name,
      required this.description,
      required this.from,
      required this.to,
      required this.source})
      : super(key: key);

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  String title = '';
  String description = '';
  DateTime startDay = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  DateTime endDay = DateTime.now();
  TimeOfDay endTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    title = widget.name;
    description = widget.description;
    String id = widget.id;
    startDay = DateTime(widget.from.year, widget.from.month, widget.from.day);
    endDay = DateTime(widget.to.year, widget.to.month, widget.to.day);
    startTime = TimeOfDay.fromDateTime(widget.from);
    endTime = TimeOfDay.fromDateTime(widget.to);
    String source = widget.source;

    return Consumer<CalsyncGoogleOAuth>(
        builder: (BuildContext context, notifier, child) {
      String email = "";
      if (notifier.getCurrentUser != null) {
        email = notifier.getCurrentUser?.email as String;
      }
      return Container(
        child: Column(children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Title'),
            onChanged: (value) => setState(() => title = value),
            initialValue: title,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Description'),
            onChanged: (value) => setState(() => description = value),
            initialValue: description,
          ),
          Text("Select the start time of your event"),
          ListTile(
            title: Text(
                // DateFormat("EEE., MMM d, yyyy").format(startDay).toString()),
                "Date: ${startDay.year}, ${startDay.month}, ${startDay.day}"),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              setState(() {
                _pickStartDate(context);
              });
            },
          ),
          ListTile(
            title: Text("Time: ${startTime.hour}:${startTime.minute}"),
            trailing: Icon(Icons.access_time),
            onTap: () {
              _pickStartTime(context);
            },
          ),
          Text("Select the end time of your event"),
          ListTile(
            title: Text("Date: ${endDay.year}, ${endDay.month}, ${endDay.day}"),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              _pickEndDate(context);
            },
          ),
          ListTile(
            title: Text("Time: ${endTime.hour}:${endTime.minute}"),
            trailing: Icon(Icons.access_time),
            onTap: () {
              _pickEndTime(context);
            },
          ),
          ElevatedButton(
              onPressed: () {
                edit_event(id, title, description, startDay, startTime, endDay,
                    endTime, email, source);
              },
              child: Text("Create Event")),
        ]),
      );
    });
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: startDay,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (selectedDate != null) {
      setState(() {
        startDay = selectedDate;
      });
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: endDay,
        firstDate: startDay,
        lastDate: DateTime(2100));
    if (selectedDate != null) {
      setState(() {
        endDay = selectedDate;
      });
    }
  }

  Future<void> _pickStartTime(BuildContext context) async {
    final TimeOfDay? t =
        await showTimePicker(context: context, initialTime: startTime);
    if (t != null) {
      setState(() {
        startTime = t;
      });
    }
  }

  Future<void> _pickEndTime(BuildContext context) async {
    final TimeOfDay? t =
        await showTimePicker(context: context, initialTime: endTime);
    if (t != null) {
      setState(() {
        endTime = t;
      });
    }
  }

  void edit_event(
      String id,
      String title,
      String description,
      DateTime startDay,
      TimeOfDay startTime,
      DateTime endDay,
      TimeOfDay endTime,
      String email,
      String source) {
    DateTime to = DateTime(startDay.year, startDay.month, startDay.day,
        startTime.hour, startTime.minute);
    DateTime from = DateTime(
        endDay.year, endDay.month, endDay.day, endTime.hour, endTime.minute);

    if (source == "firebase") {
      FirestoreCrud.updateEvent(
          id: id,
          to: to,
          from: from,
          isAllDay: false,
          name: title,
          description: description,
          email: email);
    }
    if (source == "local") {
      EventsDatabase.instance.update(Event(
          id: id,
          from: from,
          to: to,
          name: title,
          description: description,
          email: email));
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text("Created"),
                content: Text("$title - $description \n"
                    " From Date: ${startDay.year}, ${startDay.month}, ${startDay.day} Time: ${startTime.hour}:${startTime.minute} \n "
                    " To Date: ${endDay.year}, ${endDay.month}, ${endDay.day} Time: ${endTime.hour}:${endTime.minute}"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"))
                ]));
  }
}
