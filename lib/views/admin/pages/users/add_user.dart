import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/career_model.dart';
import 'package:passport_unifranz_web/models/user_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/components/headers.dart';
import 'package:passport_unifranz_web/services/services.dart';

class AddUserForm extends StatefulWidget {
  final UserModel? item;
  const AddUserForm({super.key, this.item});

  @override
  State<AddUserForm> createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  List<String> carrerIds = [];
  bool stateLoading = false;
  String? idRolSelect;
  String? idTypeUserSelect;
  bool textErrorTypeUser = false;
  bool textErrorRol = false;
  bool textErrorCarrera = false;

  @override
  void initState() {
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.name);
        emailCtrl = TextEditingController(text: widget.item!.email);
        idRolSelect = widget.item!.rol.id;
        idTypeUserSelect = widget.item!.typeUser.id;
        carrerIds = [...widget.item!.careerIds.map((e) => e.id!).toList()];
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HedersComponent(
                title: widget.item == null ? 'Nuevo Usuario' : widget.item!.name,
                initPage: false,
              ),
              (size.width > 1000)
                  ? Column(
                      children: [
                        Row(
                          children: [...titleDescription()],
                        ),
                        Row(
                          children: [...listSelect()],
                        ),
                        selectCareers()
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [...titleDescription(), ...listSelect()],
                    ),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Usuario', onPressed: () => createUser())
                      : ButtonComponent(text: 'Actualizar Usuario', onPressed: () => updateUser())
                  : Center(
                      child: Image.asset(
                      'assets/gifs/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    ))
            ],
          ),
        ),
      ),
    );
  }

  Widget selectCareers() {
    final careerBloc = BlocProvider.of<CareerBloc>(context, listen: true).state;
    final listCarrer = [...careerBloc.listCareer];
    listCarrer.sort((a, b) => a.campus.compareTo(b.campus));
    final carrers = listCarrer.map((e) => MultiSelectItem<CareerModel>(e, '${e.name}-${e.campus}')).toList();
    List<CareerModel> filteredList = [];
    if (widget.item != null) {
      filteredList = careerBloc.listCareer.where((e) => widget.item!.careerIds.any((i) => i.id == e.id)).toList();
    }
    return SelectMultiple(
      initialValue: widget.item != null ? filteredList : const [],
      items: carrers,
      labelText: 'Carrera(s):',
      hintText: 'Carrera(s)',
      error: textErrorCarrera,
      textError: 'Seleccióna una categoría',
      onChanged: (values) => setState(
        () => carrerIds = values.map((e) => careerItemModelFromJson(json.encode(e)).id).toList(),
      ),
    );
  }

  List<Widget> titleDescription() {
    return [
      Flexible(
        child: InputComponent(
            textInputAction: TextInputAction.done,
            controllerText: nameCtrl,
            onEditingComplete: () {},
            validator: (value) {
              if (value.isNotEmpty) {
                return null;
              } else {
                return 'Nombre';
              }
            },
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            labelText: "Nombre:",
            hintText: "Nombre"),
      ),
      Flexible(
        child: InputComponent(
            textInputAction: TextInputAction.done,
            controllerText: emailCtrl,
            onEditingComplete: () {},
            validator: (value) {
              if (value.isNotEmpty) {
                if (value.contains('@unifranz.edu.bo')) {
                  return null;
                } else {
                  return 'El correo no es valido';
                }
              } else {
                return 'Correo';
              }
            },
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.characters,
            labelText: "Correo:",
            hintText: "Correo"),
      ),
    ];
  }

  List<Widget> listSelect() {
    final rolBloc = BlocProvider.of<RolBloc>(context, listen: true).state;
    final typeUserBloc = BlocProvider.of<TypeUserBloc>(context, listen: true).state;
    return [
      Flexible(
        child: SelectComponent(
          subtitle: '',
          title: 'Rol:',
          options: rolBloc.listRoles.where((e) => e.state).toList(),
          defect: widget.item == null ? null : widget.item!.rol.name,
          values: (idSelect) => setState(() => idRolSelect = idSelect),
          error: textErrorRol,
          textError: 'Seleccióna una categoría',
        ),
      ),
      Flexible(
        child: SelectComponent(
          subtitle: '',
          title: 'Tipos de usuarios:',
          options: typeUserBloc.listTypeUser.where((e) => e.state).toList(),
          defect: widget.item == null ? null : widget.item!.typeUser.name,
          values: (idSelect) => setState(() => idTypeUserSelect = idSelect),
          error: textErrorTypeUser,
          textError: 'Agrega un Tipo de usuario',
        ),
      ),
    ];
  }

  createUser() async {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    if (idTypeUserSelect == null) return setState(() => textErrorTypeUser = !textErrorTypeUser);
    if (idRolSelect == null) return setState(() => textErrorRol = !textErrorRol);
    if (carrerIds.isEmpty) return setState(() => textErrorCarrera = !textErrorCarrera);
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'type_user': idTypeUserSelect,
      'rol': idRolSelect,
      'careerIds': carrerIds,
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(users(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      userBloc.add(AddItemUser(userItemModelFromJson(json.encode(res.data['usuario']))));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateUser() {
    final userBloc = BlocProvider.of<UserBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    final Map<String, dynamic> body = {
      'name': nameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'type_user': idTypeUserSelect,
      'rol': idRolSelect,
      'careerIds': carrerIds,
    };
    return CafeApi.put(users(widget.item!.id), body).then((res) async {
      final typeUserEdit = userItemModelFromJson(json.encode(res.data['usuario']));
      userBloc.add(UpdateItemUser(typeUserEdit));
      Navigator.pop(context);
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
