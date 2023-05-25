import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/components/inputs/search.dart';
import 'package:passport_unifranz_web/models/career_model.dart';
import 'package:passport_unifranz_web/models/roles_model.dart';
import 'package:passport_unifranz_web/models/session_model.dart';
import 'package:passport_unifranz_web/models/type_users_model.dart';
import 'package:passport_unifranz_web/models/user_model.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/admin/pages/users/add_user.dart';
import 'package:passport_unifranz_web/views/admin/pages/users/users_datasource.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    callAllUsers();
    callAllCareers();
    callAllRoles();
    callAllTypeUsers();
    super.initState();
  }

// UpdateListUser
  callAllUsers() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    debugPrint('obteniendo todas las categorias');
    CafeApi.configureDio();
    return CafeApi.httpGet(users(null)).then((res) async {
      debugPrint('USUARIOS');
      debugPrint(' ressssss ${json.encode(res.data['usuarios'])}');
      userBloc.add(UpdateListUser(userModelFromJson(json.encode(res.data['usuarios']))));
    });
  }

  callAllCareers() async {
    final careerBloc = BlocProvider.of<CareerBloc>(context, listen: false);
    debugPrint('obteniendo todas las carreras');
    CafeApi.configureDio();
    return CafeApi.httpGet(careers()).then((res) async {
      debugPrint('CARRERAS');
      debugPrint(' ressssss ${json.encode(res.data['carreras'])}');
      careerBloc.add(UpdateListCareer(careerModelFromJson(json.encode(res.data['carreras']))));
    });
  }

  callAllRoles() async {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: false);
    debugPrint('obteniendo todos los roles');
    CafeApi.configureDio();
    return CafeApi.httpGet(roles(null)).then((res) async {
      debugPrint('ROLES');
      debugPrint(' ressssss ${json.encode(res.data['roles'])}');
      rolBloc.add(UpdateListRol(rolesModelFromJson(json.encode(res.data['roles']))));
    });
  }

  callAllTypeUsers() async {
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: false);
    debugPrint('obteniendo todos los tipos de usuarios');
    CafeApi.configureDio();
    return CafeApi.httpGet(typeUsers(null)).then((res) async {
      debugPrint('TIPOS DE USUARIOS');
      debugPrint(' ressssss ${json.encode(res.data['tiposUsuarios'])}');
      typeUserBloc.add(UpdateListTypeUser(typeUserModelFromJson(json.encode(res.data['tiposUsuarios']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final session = sessionModelFromJson(LocalStorage.prefs.getString('userData')!);
    final userBloc = BlocProvider.of<UserBloc>(context, listen: true);
    List<UserModel> listUser = userBloc.state.listUser;
    if (searchState) {
      listUser = userBloc.state.listUser
          .where((e) => e.name.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }
    final usersDataSource = UsersDataSource(
      listUser,
      (typeUser) => showEditUser(context, typeUser),
      (typeUser, state) => removeUser(typeUser, state),
    );
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Usuarios'),
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
              if (session.permisions.where((e) => e.name == 'Crear usuarios').isNotEmpty)
                ButtonComponent(text: 'Agregar nuevo Usuario', onPressed: () => showCreateUser(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: userBloc.state.ascending,
                  sortColumnIndex: userBloc.state.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (index, _) {
                          userBloc.add(UpdateSortColumnIndexUser(index));
                        }),
                    DataColumn(
                        label: const Text('Email'),
                        onSort: (index, _) {
                          userBloc.add(UpdateSortColumnIndexUser(index));
                        }),
                    DataColumn(
                        label: const Text('Tipo de Usuario'),
                        onSort: (index, _) {
                          userBloc.add(UpdateSortColumnIndexUser(index));
                        }),
                    DataColumn(
                        label: const Text('Rol'),
                        onSort: (index, _) {
                          userBloc.add(UpdateSortColumnIndexUser(index));
                        }),
                    const DataColumn(label: Text('Carreras')),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Acciones')),
                  ],
                  source: usersDataSource,
                  onPageChanged: (page) {
                    debugPrint('page: $page');
                  },
                )
              ],
            ),
          )
        ]));
  }

  showCreateUser(BuildContext context) {
    return showDialog(
        context: context, builder: (BuildContext context) => const DialogWidget(component: AddUserForm()));
  }

  showEditUser(BuildContext context, UserModel typeUser) {
    return showDialog(
        context: context, builder: (BuildContext context) => DialogWidget(component: AddUserForm(item: typeUser)));
  }

  removeUser(UserModel typeUser, bool state) {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    CafeApi.configureDio();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(deleteUsers(typeUser.id), body).then((res) async {
      final typeUserEdit = userItemModelFromJson(json.encode(res.data['usuario']));
      userBloc.add(UpdateItemUser(typeUserEdit));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
