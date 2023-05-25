import 'package:calendar_view/calendar_view.dart' as calendar;
import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/event_model.dart';

class WeekView extends StatefulWidget {
  final double width;
  const WeekView({super.key, required this.width});

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  @override
  Widget build(BuildContext context) {
    return calendar.WeekView<EventModel>(width: widget.width);
  }
}
