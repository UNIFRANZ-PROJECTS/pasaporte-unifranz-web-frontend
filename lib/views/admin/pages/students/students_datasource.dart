import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/student_model.dart';

class StudentsDataSource extends DataTableSource {
  final List<StudentModel> users;

  StudentsDataSource(this.users);

  @override
  DataRow getRow(int index) {
    final StudentModel user = users[index];

    // final image = (user.img == null)
    //     ? Image(
    //         image: AssetImage('no-image.jpg'),
    //         width: 35,
    //         height: 35,
    //       )
    //     : FadeInImage.assetNetwork(
    //         placeholder: 'loader.gif',
    //         image: user.img!,
    //         width: 35,
    //         height: 35,
    //       );

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(user.codigo)),
      DataCell(Text(user.ci)),
      DataCell(Text(user.nombre)),
      DataCell(Text(user.apellido)),
      DataCell(Text(user.email)),
      DataCell(Text(user.sede)),
      DataCell(Text(user.carrera)),
      DataCell(Text(user.semestre)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
