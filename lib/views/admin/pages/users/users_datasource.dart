import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/session_model.dart';
import 'package:passport_unifranz_web/models/user_model.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';

class UsersDataSource extends DataTableSource {
  final Function(UserModel) editUser;
  final Function(UserModel, bool) deleteUser;
  final List<UserModel> users;

  UsersDataSource(this.users, this.editUser, this.deleteUser);

  @override
  DataRow getRow(int index) {
    final session = sessionModelFromJson(LocalStorage.prefs.getString('userData')!);
    final UserModel user = users[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(user.name)),
      DataCell(Text(user.email)),
      DataCell(Text(user.typeUser.name)),
      DataCell(Text(user.rol.name)),
      DataCell(IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: () {})),
      DataCell(Text(user.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          if (session.permisions.where((e) => e.name == 'Editar usuarios').isNotEmpty)
            IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editUser(user)),
          if (session.permisions.where((e) => e.name == 'Editar usuarios').isNotEmpty)
            Transform.scale(
                scale: .5,
                child: Switch(
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    inactiveThumbColor: Colors.white,
                    activeColor: Colors.white,
                    value: user.state,
                    onChanged: (state) => deleteUser(user, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
