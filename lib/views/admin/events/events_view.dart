import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/career_model.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/models/event_model.dart';
import 'package:passport_unifranz_web/models/guest_model.dart';
import 'package:passport_unifranz_web/models/student_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/admin/events/add_event.dart';
import 'package:passport_unifranz_web/views/admin/events/dialog_chart.dart';
import 'package:passport_unifranz_web/views/admin/events/dialog_event.dart';

import 'events_datasource.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  @override
  void initState() {
    callAllEvents();
    super.initState();
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
    final eventBloc = BlocProvider.of<EventBloc>(context, listen: true);

    final eventsDataSource = EventsDataSource(
      eventBloc.state.listEvents,
      (event) => showEditEvent(context, event),
      (event, state) => removeEvent(event, state),
      (event) => showEvent(context, event),
      (event) => showChart(context, event),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Eventos'),
              ButtonComponent(text: 'Agregar nuevo Evento', onPressed: () => showAddEvent(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: eventBloc.state.ascending,
                  sortColumnIndex: eventBloc.state.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (colIndex, _) {
                          // eventBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    const DataColumn(
                      label: Text('Imagen'),
                    ),
                    DataColumn(
                        label: const Text('Inicio'),
                        onSort: (colIndex, _) {
                          // eventBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Fin'),
                        onSort: (colIndex, _) {
                          // eventBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Modalidad')),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Acciones')),
                  ],
                  source: eventsDataSource,
                  onPageChanged: (page) {
                    debugPrint('page: $page');
                  },
                )
              ],
            ),
          )
        ]));
  }

  void showChart(BuildContext context, EventModel event) {
    showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: DialogChartEvent(event: event)));
  }

  void showEvent(BuildContext context, EventModel event) {
    showDialog(context: context, builder: (BuildContext context) => DialogWidget(component: DialogEvent(event: event)));
  }

  void showAddEvent(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const DialogWidget(
              component: AddEventForm(titleheader: 'Nuevo Evento'),
            ));
  }

  showEditEvent(BuildContext context, EventModel event) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: AddEventForm(item: event, titleheader: event.title)));
  }

  removeEvent(EventModel event, bool state) {
    final eventBloc = BlocProvider.of<EventBloc>(context, listen: false);
    CafeApi.configureDio();
    FormData formData = FormData.fromMap({
      'state': state,
    });
    return CafeApi.put(events(event.id), formData).then((res) async {
      final categoryEdit = eventItemModelFromJson(json.encode(res.data['evento']));
      eventBloc.add(UpdateItemEvent(categoryEdit));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  showCategories(BuildContext context, List<CategoryModel> categoriesIds) {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Categorias',
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                  categoriesIds.length,
                  (index) => ListTile(
                        title: Text(categoriesIds[index].title),
                      )),
            ).toList(),
          ),
        ),
      ),
    );
  }

  showGuests(BuildContext context, List<GuestModel> guestIds) {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Expositores',
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                  guestIds.length,
                  (index) => ListTile(
                        title: Text(guestIds[index].firstName),
                      )),
            ).toList(),
          ),
        ),
      ),
    );
  }

  showCareers(BuildContext context, List<CareerModel> careerIds) {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Carreras',
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                  careerIds.length,
                  (index) => ListTile(
                        title: Text(careerIds[index].name),
                      )),
            ).toList(),
          ),
        ),
      ),
    );
  }

  showStudents(BuildContext context, List<StudentModel> students) {
    return showBarModalBottomSheet(
      enableDrag: false,
      expand: false,
      context: context,
      builder: (context) => ModalComponent(
        title: 'Estudiantes confirmados',
        child: SafeArea(
          bottom: false,
          child: ListView(
            shrinkWrap: true,
            controller: ModalScrollController.of(context),
            children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                  students.length,
                  (index) => ListTile(
                        title: Text(students[index].nombre),
                      )),
            ).toList(),
          ),
        ),
      ),
    );
  }
}
