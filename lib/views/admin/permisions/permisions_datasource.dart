import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/permisions_model.dart';

class PermisionsDataSource extends DataTableSource {
  final List<PermisionsModel> users;

  PermisionsDataSource(this.users);

  @override
  DataRow getRow(int index) {
    final PermisionsModel user = users[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(user.id)),
      DataCell(Text(user.name)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
