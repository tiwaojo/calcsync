import 'package:calendar_sync/db/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late String source, id;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController editTitleController;
  late TextEditingController editDescrptionController;
  late TextEditingController editStartDateController;
  late TextEditingController editStartTimeController;
  late TextEditingController editEndDateController;
  late TextEditingController editEndTimeController;

  @override
  void initState() {
    super.initState();
    title = widget.name;
    description = widget.description;
    id = widget.id;
    startDay = DateTime(widget.from.year, widget.from.month, widget.from.day);
    endDay = DateTime(widget.to.year, widget.to.month, widget.to.day);
    startTime = TimeOfDay.fromDateTime(widget.from);
    endTime = TimeOfDay.fromDateTime(widget.to);
    source = widget.source;

    // Controllers
    editTitleController = TextEditingController();
    editDescrptionController = TextEditingController();
    editStartDateController = TextEditingController();
    editStartTimeController = TextEditingController();
    editEndDateController = TextEditingController();
    editEndTimeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    editTitleController.dispose();
    editDescrptionController.dispose();
    editStartDateController.dispose();
    editStartTimeController.dispose();
    editEndDateController.dispose();
    editEndTimeController.dispose();
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
          margin: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 10),
          decoration: BoxDecoration(
            // color: Theme.of(context).backgroundColor,
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
                  // controller: editTitleController,
                  // updates personalized typing history
                  enableIMEPersonalizedLearning: true,
                  autocorrect: true,
                  enableSuggestions: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration:
                      InputDecoration(hintText: "Title", label: Text("Title")),
                  onChanged: (value) => setState(() => title = value),
                  initialValue: title,
                ),
                TextFormField(
                  // controller: editDescrptionController,
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
                  onChanged: (value) => setState(() => description = value),
                  initialValue: description,
                ),
                Text("Select the start time of your event"),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                        controller: editStartDateController,
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
                        autofocus: false,
                        enableInteractiveSelection: true,
                        onChanged: (value) {
                          startDay = DateTime.parse(value);
                        },
                        decoration: InputDecoration(
                          hintText: "Start Date",
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _pickStartDate(context).then((value) {
                                if (value != null) {
                                  editStartDateController.text =
                                      DateFormat("EEE., MMM d, yyyy")
                                          .format(value);
                                  setState(() {
                                    startDay = value;
                                    print(startDay);
                                  });
                                }
                              });
                            },
                            icon: Icon(Icons.calendar_today),
                          ),
                        ),
                        onSaved: (value) => setState(() {
                          // final date= DateTime.parse(value!);
                          // start_day =
                        }),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        autofocus: false,
                        controller: editStartTimeController,
                        enableIMEPersonalizedLearning: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.datetime,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter a start time";
                          } else {
                            return null;
                          }
                        },
                        enableInteractiveSelection: true,
                        onChanged: (value) {
                          final tempTime = DateTime.parse(value);
                          startTime = TimeOfDay.fromDateTime(tempTime);
                        },
                        decoration: InputDecoration(
                          hintText: "Start Time",
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _pickStartTime(context).then((value) {
                                if (value != null) {
                                  final _time = DateTime(
                                      startDay.year,
                                      startDay.month,
                                      startDay.day,
                                      value.hour,
                                      value.minute);
                                  editStartTimeController.text =
                                      DateFormat("h:mm a").format(_time);
                                  setState(() {
                                    startTime = value;
                                    print(startTime);
                                  });
                                }
                              });
                            },
                            icon: Icon(Icons.access_time),
                          ),
                        ),
                        onSaved: (value) {
                          // final tempTime = DateTime.parse(value!);
                          // DateFormat.HOUR_MINUTE;
                          // print(tempTime);
                          // setState(() {
                          //   start_time = TimeOfDay.fromDateTime(tempTime);
                          // });
                        },
                      ),
                    ),
                  ],
                ),
                Text("Select the end time of your event"),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                          controller: editEndDateController,
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
                          autofocus: false,
                          enableInteractiveSelection: true,
                          onChanged: (value) {
                            endDay = DateTime.parse(value);
                          },
                          decoration: InputDecoration(
                            hintText: "End Date",
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _pickStartDate(context).then((date) {
                                  if (date != null) {
                                    editEndDateController.text =
                                        DateFormat("EEE., MMM d, yyyy")
                                            .format(date);
                                    setState(() {
                                      endDay = date;
                                      print("End date: $endDay");
                                    });
                                  }
                                });
                              },
                              icon: Icon(Icons.calendar_today),
                            ),
                          ),
                          onSaved: (value)
                              // setState(() => description = value!),
                              {
                            print("object");
                          }),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        autofocus: false,
                        controller: editEndTimeController,
                        enableIMEPersonalizedLearning: false,
                        enableSuggestions: false,
                        keyboardType: TextInputType.datetime,
                        validator: (text) {
                          if (text!.isEmpty) {
                            return "Please enter a start time";
                          } else {
                            return null;
                          }
                        },
                        enableInteractiveSelection: true,
                        onChanged: (value) {
                          final tempTime = DateTime.parse(value);
                          endTime = TimeOfDay.fromDateTime(tempTime);
                        },
                        decoration: InputDecoration(
                          hintText: "End Time",
                          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _pickEndTime(context).then((value) {
                                if (value != null) {
                                  final _time = DateTime(
                                      endDay.year,
                                      endDay.month,
                                      endDay.day,
                                      value.hour,
                                      value.minute);
                                  editEndTimeController.text =
                                      DateFormat("h:mm a").format(_time);
                                  setState(() {
                                    endTime = value;
                                    print("End time: $endTime");
                                  });
                                }
                              });
                            },
                            icon: Icon(Icons.access_time),
                          ),
                        ),
                        onSaved: (value) {
                          // final tempTime = DateTime.parse(value!);
                          // print(tempTime);
                          // setState(() {
                          //   end_time = TimeOfDay.fromDateTime(tempTime);
                          // });
                        },
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      edit_event(id, title, description, startDay, startTime,
                          endDay, endTime, email, source);
                    },
                    child: Text("Edit Event")),
              ]),
        ),
      );
    });
  }

  Future<DateTime?> _pickStartDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: startDay,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    // if (selectedDate != null) {
    //   setState(() {
    //     startDay = selectedDate;
    //   });
    // }
  }

  Future<DateTime?> _pickEndDate(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: endDay,
        firstDate: startDay,
        lastDate: DateTime(2100));
    // if (selectedDate != null) {
    //   setState(() {
    //     endDay = selectedDate;
    //   });
    // }
  }

  Future<TimeOfDay?> _pickStartTime(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: startTime);
    // if (t != null) {
    //   setState(() {
    //     startTime = t;
    //   });
    // }
  }

  Future<TimeOfDay?> _pickEndTime(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: endTime);
    // if (t != null) {
    //   setState(() {
    //     endTime = t;
    //   });
    // }
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
    DateTime from = DateTime(startDay.year, startDay.month, startDay.day,
        startTime.hour, startTime.minute);
    DateTime to = DateTime(
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
