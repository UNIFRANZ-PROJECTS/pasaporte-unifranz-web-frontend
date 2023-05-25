import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/permisions_model.dart';

class PermisionsDataSource extends DataTableSource {
  final List<PermisionsModel> permisions;

  PermisionsDataSource(this.permisions);

  @override
  DataRow getRow(int index) {
    final PermisionsModel permision = permisions[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(permision.id)),
      DataCell(Text(permision.name)),
      DataCell(Text(permision.category)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => permisions.length;

  @override
  int get selectedRowCount => 0;
}
