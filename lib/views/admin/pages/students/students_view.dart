import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/inputs/search.dart';
import 'package:passport_unifranz_web/models/session_model.dart';
import 'package:passport_unifranz_web/models/student_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/services/services.dart';

import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/views/admin/pages/students/add_info.dart';
import 'package:passport_unifranz_web/views/admin/pages/students/students_datasource.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    super.initState();
    callAllStudents();
  }

  callAllStudents() async {
    final studentBloc = BlocProvider.of<StudentBloc>(context, listen: false);
    debugPrint('obteniendo todos los estudiantes');
    CafeApi.configureDio();
    return CafeApi.httpGet(students()).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['estudiantes'])}');
      studentBloc.add(UpdateListStudent(studentModelFromJson(json.encode(res.data['estudiantes']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final session = sessionModelFromJson(LocalStorage.prefs.getString('userData')!);
    final studentBloc = BlocProvider.of<StudentBloc>(context, listen: true);
    List<StudentModel> listEstudent = studentBloc.state.listEstudent;
    if (searchState) {
      listEstudent = studentBloc.state.listEstudent
          .where((e) => '${e.nombre} ${e.apellido} ${e.codigo}'
              .trim()
              .toUpperCase()
              .contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }

    final usersDataSource = StudentsDataSource(listEstudent);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Estudiantes'),
              SearchWidget(
                controllerText: searchCtrl,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() => searchState = true);
                  } else {
                    setState(() => searchState = false);
                  }
                },
              ),
              if (session.permisions.where((e) => e.name == 'Agregar estudiantes').isNotEmpty)
                ButtonComponent(text: 'Agregar archivo de estudiantes', onPressed: () => callDialogAction(context)),
            ],
          ),
          const SizedBox(height: 10),
          PaginatedDataTable(
            sortAscending: studentBloc.state.ascending,
            sortColumnIndex: studentBloc.state.sortColumnIndex,
            columns: const [
              DataColumn(label: Text('Codigo')),
              DataColumn(label: Text('CI')),
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Apellido')),
              DataColumn(label: Text('Correo')),
              DataColumn(label: Text('Sede')),
              DataColumn(label: Text('Carrera')),
              DataColumn(label: Text('Semestre')),
            ],
            source: usersDataSource,
            onPageChanged: (page) {
              debugPrint('page: $page');
            },
          )
        ],
      ),
    );
  }

  void callDialogAction(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const DialogWidget(
              component: AddStedentsData(),
            ));
  }
}
