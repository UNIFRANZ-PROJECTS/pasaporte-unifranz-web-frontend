import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/permisions_model.dart';
import 'package:passport_unifranz_web/models/roles_model.dart';
import 'package:passport_unifranz_web/models/session_model.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';

class RolesDataSource extends DataTableSource {
  final Function(RolesModel) editRol;
  final Function(RolesModel, bool) deleteRol;
  final Function(List<PermisionsModel>) permisions;
  final List<RolesModel> roles;

  RolesDataSource(this.roles, this.editRol, this.deleteRol, this.permisions);

  @override
  DataRow getRow(int index) {
    final session = sessionModelFromJson(LocalStorage.prefs.getString('userData')!);
    final RolesModel rol = roles[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(rol.name)),
      DataCell(IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: () => permisions(rol.permisionIds))),
      DataCell(Text(rol.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          if (session.permisions.where((e) => e.name == 'Editar roles').isNotEmpty)
            IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editRol(rol)),
          if (session.permisions.where((e) => e.name == 'Eliminar roles').isNotEmpty)
            Transform.scale(
                scale: .5,
                child: Switch(
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    inactiveThumbColor: Colors.white,
                    activeColor: Colors.white,
                    value: rol.state,
                    onChanged: (state) => deleteRol(rol, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => roles.length;

  @override
  int get selectedRowCount => 0;
}
