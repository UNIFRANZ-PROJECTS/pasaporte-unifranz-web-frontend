import 'package:calendar_view/calendar_view.dart' as calendar;
import 'package:flutter/material.dart';

import 'package:passport_unifranz_web/models/event_model.dart';

class DayView extends StatefulWidget {
  final Function(List<calendar.CalendarEventData<EventModel>>, DateTime) onEventTap;
  final double width;
  final DateTime initialDay;
  const DayView({super.key, required this.width, required this.initialDay, required this.onEventTap});

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
  @override
  Widget build(BuildContext context) {
    return calendar.DayView<EventModel>(
      heightPerMinute: 2,
      // Widget Function(DateTime)? timeLineBuilder,
      // double? timeLineWidth,
      // double timeLineOffset = 0,
      // description:'',
      eventTileBuilder: (date, events, boundry, start, end) {
        // Return your widget to display as event tile.
        return SingleChildScrollView(
          child: Column(
            children: [
              Text(events[0].event!.title),
              Text(events[0].event!.description),
            ],
          ),
        );
      },
      initialDay: widget.initialDay,
      width: widget.width,
      onEventTap: (events, date) => widget.onEventTap(events, date),
    );
  }
}
