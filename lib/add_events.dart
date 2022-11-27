import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descrptionController;
  late TextEditingController startDateController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descrptionController = TextEditingController();
    startDateController = TextEditingController();
    // saveEvent();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descrptionController.dispose();
    startDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalsyncGoogleOAuth>(
        builder: (BuildContext context, notifier, child) {
      String email = "";
      if (notifier.getCurrentUser != null) {
        email = notifier.getCurrentUser?.email as String;
      }
      return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          // height: MediaQuery.of(context).viewInsets.bottom + 350.0,
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: titleController,
                  // updates personalized typing history
                  enableIMEPersonalizedLearning: true,
                  autocorrect: true,
                  enableSuggestions: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration:
                      InputDecoration(hintText: "Title", label: Text("Title")),
                  onSaved: (value) => setState(() => title = value!),
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Please enter a title";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: descrptionController,
                  enableIMEPersonalizedLearning: true,
                  enableSuggestions: true,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Please enter a description";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Description",
                    label: Text("Description"),
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  ),
                  onSaved: (value) => setState(() => description = value!),
                ),
                Text("Select the start time of your event"),
                // InputDatePickerFormField( // Do not use. Style incompatible...
                //   firstDate: start_day,
                //   lastDate: DateTime(start_day.year + 5),
                //   keyboardType: TextInputType.datetime,
                //   initialDate: start_day,
                //   onDateSaved: (value) {
                //     print(value);
                //     // return va
                //   },
                // ),
                TextFormField(
                  controller: startDateController,
                  enableIMEPersonalizedLearning: true,
                  enableSuggestions: true,
                  keyboardType: TextInputType.datetime,
                  validator: (text) {
                    if (text!.isEmpty) {
                      return "Please enter a date";
                    } else {
                      return null;
                    }
                  },
                  enableInteractiveSelection: true,
                  onChanged: (value) {
                    start_day = DateTime.parse(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Date",
                    contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _pickStartDate(context).then((date) {
                          if (date != null) {
                            startDateController.text =
                                DateFormat("EEE., MMM d, yyyy").format(date);
                            // date.toLocal().toString();
                            setState(() {
                              start_day = date;
                              print(start_day);
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.calendar_today),
                    ),
                  ),
                  // onSaved: (value) => setState(() => description = value!),
                ),
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
                  title: Text(
                      "Date: ${end_day.year}, ${end_day.month}, ${end_day.day}"),
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
                      bool? isValid = _formKey.currentState
                          ?.validate(); // validates the content of our form

                      FocusScope.of(context)
                          .unfocus(); // Remove keyboard from focus

                      if (isValid!) {
                        _formKey.currentState
                            ?.save(); // executes the onSave callback methods in our form fields
                        create_event(title, description, start_day, start_time,
                            end_day, end_time, email);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(// Event saved snackbar is displayed
                                SnackBar(
                          content: Text('Event Added'),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Error: Event Not Added'),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: Text("Create Event")),
              ]),
        ),
      );
    });
  }

  Future<DateTime?> _pickStartDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: start_day,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
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
