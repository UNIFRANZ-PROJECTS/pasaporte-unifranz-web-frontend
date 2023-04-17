import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/models/student_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/admin/students/add_info.dart';
import 'package:passport_unifranz_web/views/admin/students/students_datasource.dart';

import 'package:passport_unifranz_web/components/compoents.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
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
    final studentBloc = BlocProvider.of<StudentBloc>(context, listen: true);

    // final categoriesDataSource = CategoriesDataSource(categoryBloc.state.listCategories);
    // final usersProvider = Provider.of<UsersProvider>(context);

    final usersDataSource = StudentsDataSource(studentBloc.state.listEstudent);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Estudiantes'),
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
