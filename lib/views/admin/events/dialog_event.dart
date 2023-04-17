import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passport_unifranz_web/models/event_model.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/admin/calendar/student_confirmed.dart';
import 'package:passport_unifranz_web/views/admin/guests/guests_datasource.dart';
import 'package:printing/printing.dart';

class DialogEvent extends StatefulWidget {
  final EventModel event;

  const DialogEvent({super.key, required this.event});

  @override
  State<DialogEvent> createState() => _DialogEventState();
}

class _DialogEventState extends State<DialogEvent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  String? imageFile;
  Uint8List? bytes;
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    final students = widget.event.studentIds;
    final guests = widget.event.guestIds;
    debugPrint('students $students');
    final studentsDataSource = DataStudentsConfirm(students);
    final guestsDataSource = GuestsDataSource(guests, null, null);
    debugPrint('studentsDataSource $studentsDataSource');
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
                child: Image.network(
                  widget.event.image,
                  height: 200,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  Text(widget.event.description),
                  const SizedBox(height: 20),
                  const Text(
                    'Expositores',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        PaginatedDataTable(
                          // sortAscending: categoryBloc.state.ascending,
                          // sortColumnIndex: categoryBloc.state.sortColumnIndex,
                          columns: [
                            DataColumn(
                                label: const Text('Nombre'),
                                onSort: (colIndex, _) {
                                  // guestBloc.add(UpdateSortColumnIndexCategory(colIndex));
                                }),
                            DataColumn(
                                label: const Text('Apellido'),
                                onSort: (colIndex, _) {
                                  // guestBloc.add(UpdateSortColumnIndexCategory(colIndex));
                                }),
                            const DataColumn(
                              label: Text('Imagen'),
                            ),
                            const DataColumn(label: Text('Especialidad')),
                            const DataColumn(label: Text('Descripcion')),
                            const DataColumn(label: Text('Estado')),
                          ],
                          source: guestsDataSource,
                          onPageChanged: (page) {
                            debugPrint('page: $page');
                          },
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Estudiantes confirmados',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ButtonComponent(text: 'Descargar', onPressed: () => downloadReport(context))
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        PaginatedDataTable(
                          // sortAscending: categoryBloc.state.ascending,
                          // sortColumnIndex: categoryBloc.state.sortColumnIndex,
                          columns: [
                            const DataColumn(label: Text('Código')),
                            DataColumn(
                                label: const Text('Nombre'),
                                onSort: (colIndex, _) {
                                  // usersProvider.sortColumnIndex = colIndex;
                                  // usersProvider.sort<String>((user) => user.nombre);
                                }),
                            const DataColumn(label: Text('Apellido')),
                            const DataColumn(label: Text('Correo')),
                            const DataColumn(label: Text('Sede')),
                            const DataColumn(label: Text('Carrera')),
                            const DataColumn(label: Text('Semestre')),
                          ],
                          source: studentsDataSource,
                          onPageChanged: (page) {
                            debugPrint('page: $page');
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  downloadReport(BuildContext context) {
    debugPrint('obteniendo toda la info para dashboar');
    CafeApi.configureDio();
    return CafeApi.httpGet(reportStudentsByEvent(widget.event.id)).then((res) async {
      final bytes = base64Decode(res.data['base64']);
      await Printing.sharePdf(bytes: bytes, filename: '${widget.event.id}.xlsx');
    });
  }
}
