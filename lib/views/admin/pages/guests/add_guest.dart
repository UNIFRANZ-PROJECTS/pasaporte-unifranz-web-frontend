import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/models/guest_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/components/headers.dart';
import 'package:passport_unifranz_web/services/services.dart';

import 'package:passport_unifranz_web/components/compoents.dart';

class AddGuestForm extends StatefulWidget {
  final String titleheader;
  final GuestModel? item;
  const AddGuestForm({super.key, this.item, required this.titleheader});

  @override
  State<AddGuestForm> createState() => _AddGuestFormState();
}

class _AddGuestFormState extends State<AddGuestForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController specialtyCtrl = TextEditingController();
  String? imageFile;
  String? bytes;
  bool stateLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      setState(() {
        nameCtrl = TextEditingController(text: widget.item!.firstName);
        lastNameCtrl = TextEditingController(text: widget.item!.lastName);
        descriptionCtrl = TextEditingController(text: widget.item!.description);
        specialtyCtrl = TextEditingController(text: widget.item!.specialty);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(children: [
              HedersComponent(
                title: widget.titleheader,
                initPage: false,
              ),
              (size.width > 1000)
                  ? Row(children: [for (final item in inputs()) Expanded(child: item)])
                  : Column(children: inputs()),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Expositor', onPressed: () => createGuest())
                      : ButtonComponent(text: 'Actualizar Expositor', onPressed: () => updateGuest())
                  : Center(
                      child: Image.asset(
                      'assets/gifs/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    ))
            ]))));
  }

  List<Widget> inputs() {
    return [
      ImageInputComponent(
        defect: widget.item == null ? null : widget.item!.image,
        onPressed: (imageBytes) => setState(() => bytes = imageBytes),
      ),
      Column(
        children: [
          InputComponent(
              textInputAction: TextInputAction.done,
              controllerText: nameCtrl,
              onEditingComplete: () {},
              validator: (value) {
                if (value.isNotEmpty) {
                  return null;
                } else {
                  return 'complemento';
                }
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              labelText: "Nombre(s):",
              hintText: "Nombre(s) del expositor"),
          InputComponent(
              textInputAction: TextInputAction.done,
              controllerText: lastNameCtrl,
              onEditingComplete: () {},
              validator: (value) {
                if (value.isNotEmpty) {
                  return null;
                } else {
                  return 'complemento';
                }
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              labelText: "Apellido(s):",
              hintText: "Apellido(s) del expositor"),
          InputComponent(
              textInputAction: TextInputAction.done,
              controllerText: specialtyCtrl,
              onEditingComplete: () {},
              validator: (value) {
                if (value.isNotEmpty) {
                  return null;
                } else {
                  return 'complemento';
                }
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              labelText: "Especialidad(s):",
              hintText: "Especialidad(s) del expositor"),
          InputComponent(
              controllerText: descriptionCtrl,
              onEditingComplete: () {},
              validator: (value) {
                if (value.trim() == "") return "Ingresa una descripción para el evento.";
                return null;
              },
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              minLines: 1,
              maxLines: 10,
              maxLength: 1000,
              textCapitalization: TextCapitalization.characters,
              labelText: "Descripción:",
              hintText: "Descripción del expositor"),
        ],
      ),
    ];
  }

  createGuest() async {
    final guestBloc = BlocProvider.of<GuestBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'first_name': nameCtrl.text.trim(),
      'last_name': lastNameCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'specialty': specialtyCtrl.text.trim(),
      'archivo': bytes!,
    };
    return CafeApi.post(guests(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final guest = guestItemModelFromJson(json.encode(res.data['invitado']));
      guestBloc.add(AddItemListGuest(guest));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateGuest() {
    final guestBloc = BlocProvider.of<GuestBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    final Map<String, dynamic> body = {
      'first_name': nameCtrl.text.trim(),
      'last_name': lastNameCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'specialty': specialtyCtrl.text.trim(),
      'archivo': bytes != null ? bytes! : null,
    };
    return CafeApi.put(guests(widget.item!.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final guestEdit = guestItemModelFromJson(json.encode(res.data['invitado']));
      guestBloc.add(UpdateItemGuest(guestEdit));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
