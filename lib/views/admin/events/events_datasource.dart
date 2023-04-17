import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passport_unifranz_web/models/event_model.dart';

class EventsDataSource extends DataTableSource {
  final List<EventModel> events;
  final Function(EventModel) editTypeUser;
  final Function(EventModel, bool) deleteTypeUser;
  final Function(EventModel) showEvent;
  final Function(EventModel) showEventChart;

  EventsDataSource(
    this.events,
    this.editTypeUser,
    this.deleteTypeUser,
    this.showEvent,
    this.showEventChart,
  );

  @override
  DataRow getRow(int index) {
    final EventModel event = events[index];

    final image = FadeInImage.assetNetwork(
      placeholder: 'gifs/loader.gif',
      image: event.image,
      width: 35,
      height: 35,
    );

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(event.title)),
      DataCell(ClipOval(
        child: image,
      )),
      DataCell(Text(DateFormat('dd, MMMM yyyy ', "es_ES").format(event.start))),
      DataCell(Text(DateFormat('dd, MMMM yyyy ', "es_ES").format(event.end))),
      DataCell(Text(event.stateEvent)),
      DataCell(Text(event.modality)),
      DataCell(Text(event.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.bar_chart_sharp), onPressed: () => showEventChart(event)),
          IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: () => showEvent(event)),
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editTypeUser(event)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: event.state,
                  onChanged: (state) => deleteTypeUser(event, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => events.length;

  @override
  int get selectedRowCount => 0;
}
