import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/student_model.dart';

class DataStudentsConfirm extends DataTableSource {
  final List<StudentModel> students;

  DataStudentsConfirm(this.students);

  @override
  DataRow getRow(int index) {
    final StudentModel student = students[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(student.codigo)),
      DataCell(Text(student.nombre)),
      DataCell(Text(student.apellido)),
      DataCell(Text(student.email)),
      DataCell(Text(student.sede)),
      DataCell(Text(student.carrera)),
      DataCell(Text(student.semestre)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => students.length;

  @override
  int get selectedRowCount => 0;
}
