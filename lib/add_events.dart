import 'package:flutter/material.dart';
import 'dart:async';

class add_events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: " Test",
      home: addEvent(),
    );
  }
}

class addEvent extends StatefulWidget {
  @override
  State<addEvent> createState() => _addEventState();
}

class _addEventState extends State<addEvent> {
  DateTime day = DateTime.now();

  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(children: [
          TextFormField(
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Description'),
          ),
          Text("Select the time of your Reminder"),
          ListTile(
            title: Text("Date: ${day.year}, ${day.month}, ${day.day}"),
            trailing: Icon(Icons.calendar_today),
            onTap: () {
              _pickDate(context);
            },
          ),
          ListTile(
            title: Text("Time: ${time.hour}:${time.minute}"),
            trailing: Icon(Icons.access_time),
            onTap: () {
              _pickTime(context);
            },
          )
        ]),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: day,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (selectedDate != null) {
      setState(() {
        day = selectedDate;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? t =
        await showTimePicker(context: context, initialTime: time);
    if (t != null) {
      setState(() {
        time = t;
      });
    }
  }
}
