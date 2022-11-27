import 'package:calendar_sync/views/calendar.dart';
import 'package:flutter/material.dart';

class MonthPage extends StatefulWidget {
  const MonthPage({Key? key}) : super(key: key);

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MonthView(),
    );
  }
}
