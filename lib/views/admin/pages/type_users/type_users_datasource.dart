import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/session_model.dart';
import 'package:passport_unifranz_web/models/type_users_model.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';

class TypeUsersDataSource extends DataTableSource {
  final Function(TypeUserModel) editTypeUser;
  final Function(TypeUserModel, bool) deleteTypeUser;
  final List<TypeUserModel> typeUsers;

  TypeUsersDataSource(this.typeUsers, this.editTypeUser, this.deleteTypeUser);

  @override
  DataRow getRow(int index) {
    final session = sessionModelFromJson(LocalStorage.prefs.getString('userData')!);
    final TypeUserModel typeUser = typeUsers[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(typeUser.name)),
      DataCell(Text(typeUser.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          if (session.permisions.where((e) => e.name == 'Editar tipos de usuario').isNotEmpty)
            IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editTypeUser(typeUser)),
          if (session.permisions.where((e) => e.name == 'Eliminar tipos de usuario').isNotEmpty)
            Transform.scale(
                scale: .5,
                child: Switch(
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    inactiveThumbColor: Colors.white,
                    activeColor: Colors.white,
                    value: typeUser.state,
                    onChanged: (state) => deleteTypeUser(typeUser, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => typeUsers.length;

  @override
  int get selectedRowCount => 0;
}
