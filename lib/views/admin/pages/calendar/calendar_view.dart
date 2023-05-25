import 'dart:convert';

import 'package:calendar_view/calendar_view.dart' as calendar;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/models/event_model.dart';
import 'package:passport_unifranz_web/views/home/card_category.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';

import '../calendar/day_view.dart';
import '../calendar/month_view.dart';
import '../calendar/week_view.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarView _selectedView = CalendarView.month;
  DateTime dateSelected = DateTime.now();
  @override
  void initState() {
    callAllCategories();
    callAllEvents();
    super.initState();
  }

  callAllCategories() async {
    final eventBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    debugPrint('obteniendo todas las categorias');

    return CafeApi.httpGet(categories(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['categorias'])}');
      eventBloc.add(UpdateListCategory(categoryModelFromJson(json.encode(res.data['categorias']))));
    });
  }

  callAllEvents() async {
    final eventBloc = BlocProvider.of<EventBloc>(context, listen: false);
    debugPrint('obteniendo todos los eventos');
    return CafeApi.httpGet(events(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['eventos'])}');
      eventBloc.add(UpdateListEvent(eventModelFromJson(json.encode(res.data['eventos']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventBloc = BlocProvider.of<EventBloc>(context, listen: true).state;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    children: [for (final category in state.listCategories) CategoryWidget(category: category)],
                  ),
                );
              })),
          Expanded(
              child: eventBloc.existEvents
                  ? calendar.CalendarControllerProvider<EventModel>(
                      controller: eventBloc.eventCtrl!,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () => setState(() => _selectedView = CalendarView.month),
                                  child: const Icon(Icons.arrow_back_ios)),
                              Text(DateFormat('dd, MMMM yyyy ', "es_ES").format(DateTime.now())),
                            ],
                          ),
                          Expanded(
                            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                              return _selectedView == CalendarView.month
                                  ? MonthView(
                                      width: constraints.maxWidth,
                                      events: (day) => setState(() {
                                        _selectedView = CalendarView.day;
                                        dateSelected = day;
                                      }),
                                    )
                                  : _selectedView == CalendarView.day
                                      ? DayView(
                                          width: constraints.maxWidth,
                                          initialDay: dateSelected,
                                          onEventTap: (events, date) => showEvent(context, events),
                                        )
                                      : WeekView(width: constraints.maxWidth);
                            }),
                          ),
                        ],
                      ),
                    )
                  : Container())
        ],
      ),
    );
  }

  void showEvent(BuildContext context, List<calendar.CalendarEventData<EventModel>> events) {
    // showDialog(
    //     context: context, builder: (BuildContext context) => DialogWidget(component: DialogEvent(events: events)));
  }
}

enum CalendarView {
  month,
  day,
  week,
}
