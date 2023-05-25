import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/session_model.dart';

import 'package:passport_unifranz_web/services/local_storage.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  bool stateLoading = false;
  @override
  Widget build(BuildContext context) {
    final session = sessionModelFromJson(LocalStorage.prefs.getString('userData')!);
    return Drawer(
      width: MediaQuery.of(context).size.width / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.network(session.image),
                          ),
                        )),
                    Text(
                      'Hola ${session.name}!',
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Stack(children: [
              // const Formtop(),
              // const FormButtom(),
              SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Mis datos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ItemList(
                        icon: Icons.badge_sharp,
                        text: 'Rol: ${session.rol}',
                      ),
                      ItemList(
                        icon: Icons.badge_sharp,
                        text: 'Tipo de usuario: ${session.typeUser}',
                      ),
                      const Text(
                        'Carreras:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                            border: TableBorder.all(color: Colors.black),
                            columnWidths: const {
                              0: FlexColumnWidth(4),
                              1: FlexColumnWidth(7),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              for (final item in session.careerIds) tableInfo(item.abbreviation, item.campus),
                            ]),
                      ),
                      const Divider(height: 0.03),
                      const Text(
                        'Configuración general',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ItemList(
                        icon: Icons.lock,
                        text: 'Cambiar contraseña',
                        stateLoading: stateLoading,
                        onPressed: () {},
                      ),
                    ],
                  )),
            ]),
          ),
        ],
      ),
    );
  }
}
