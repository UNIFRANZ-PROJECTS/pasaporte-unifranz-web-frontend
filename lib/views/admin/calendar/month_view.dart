import 'package:calendar_view/calendar_view.dart' as calendar;
import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/event_model.dart';

class MonthView extends StatefulWidget {
  final double width;
  final Function(DateTime) events;
  const MonthView({super.key, required this.width, required this.events});

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  @override
  Widget build(BuildContext context) {
    return calendar.MonthView<EventModel>(
        weekDayBuilder: (int i) {
          switch (i) {
            case 0:
              return const Center(child: Text('Lunes'));
            case 1:
              return const Center(child: Text('Martes'));
            case 2:
              return const Center(child: Text('Miercoles'));
            case 3:
              return const Center(child: Text('Jueves'));
            case 4:
              return const Center(child: Text('Viernes'));
            case 5:
              return const Center(child: Text('Sábado'));
            case 6:
              return const Center(child: Text('Domingo'));
            default:
              return const Center(child: Text(''));
          }
        },
        onCellTap: (events, date) {
          events.isNotEmpty ? widget.events(date) : debugPrint('');
        },
        cellAspectRatio: 1,
        cellBuilder: (date, events, isToday, isInMonth) {
          // Return your widget to display as month cell.
          return Column(
            children: [
              Container(
                decoration: isToday
                    ? BoxDecoration(
                        border: Border.all(width: 2),
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      )
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text('${date.day}')),
                ),
              ),
              events.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1), borderRadius: const BorderRadius.all(Radius.circular(8))),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                'Dīa con eventos',
                              )),
                            ),
                          ),
                          const Positioned(
                              right: 0,
                              top: 0,
                              child: Icon(
                                Icons.attachment_outlined,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    )
                  : Container()
            ],
          );
          // return Column(
          //   children: [Text('isToday $isToday'), Text('date $isInMonth')],
          // );
        },
        onEventTap: (event, date) => debugPrint('event$event'),
        onDateLongPress: (date) => debugPrint('date$date'),
        width: widget.width);
  }
}
