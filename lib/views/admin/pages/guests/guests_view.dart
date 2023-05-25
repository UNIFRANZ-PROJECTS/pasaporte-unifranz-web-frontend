import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/components/inputs/search.dart';
import 'package:passport_unifranz_web/models/guest_model.dart';
import 'package:passport_unifranz_web/models/session_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/local_storage.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/admin/pages/guests/add_guest.dart';
import 'package:passport_unifranz_web/views/admin/pages/guests/guests_datasource.dart';

class GuestsView extends StatefulWidget {
  const GuestsView({super.key});

  @override
  State<GuestsView> createState() => _GuestsViewState();
}

class _GuestsViewState extends State<GuestsView> {
  TextEditingController searchCtrl = TextEditingController();
  bool searchState = false;
  @override
  void initState() {
    callAllGuests();
    super.initState();
  }

  callAllGuests() async {
    debugPrint('obteniendo todas los expositores');
    final guestBloc = BlocProvider.of<GuestBloc>(context, listen: false);
    return CafeApi.httpGet(guests(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['invitados'])}');
      guestBloc.add(UpdateListGuest(guestModelFromJson(json.encode(res.data['invitados']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final session = sessionModelFromJson(LocalStorage.prefs.getString('userData')!);
    final guestBloc = BlocProvider.of<GuestBloc>(context, listen: true);
    List<GuestModel> listGuest = guestBloc.state.listGuests;
    if (searchState) {
      listGuest = guestBloc.state.listGuests
          .where(
              (e) => '${e.firstName} ${e.lastName}'.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }
    final guestsDataSource = GuestsDataSource(
      listGuest,
      (typeUser) => showEditGuest(context, typeUser),
      (typeUser, state) => removeGuest(typeUser, state),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (size.width > 1000) const Text('Expositores'),
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
              if (session.permisions.where((e) => e.name == 'Crear expositores').isNotEmpty)
                ButtonComponent(text: 'Agregar nuevo Expositor', onPressed: () => showAddGuest(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: guestBloc.state.ascending,
                  sortColumnIndex: guestBloc.state.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (colIndex, _) {
                          // guestBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    DataColumn(
                        label: const Text('Apellido'),
                        onSort: (colIndex, _) {
                          // guestBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    const DataColumn(
                      label: Text('Imagen'),
                    ),
                    const DataColumn(label: Text('Especialidad')),
                    const DataColumn(label: Text('Descripcion')),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Acciones')),
                  ],
                  source: guestsDataSource,
                  onPageChanged: (page) {
                    debugPrint('page: $page');
                  },
                )
              ],
            ),
          )
        ]));
  }

  void showAddGuest(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const DialogWidget(component: AddGuestForm(titleheader: 'Nuevo Expositor')));
  }

  showEditGuest(BuildContext context, GuestModel guest) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => DialogWidget(
                component: AddGuestForm(
              item: guest,
              titleheader: guest.firstName,
            )));
  }

  removeGuest(GuestModel guest, bool state) {
    final guestBloc = BlocProvider.of<GuestBloc>(context, listen: false);
    CafeApi.configureDio();
    final Map<String, dynamic> body = {
      'state': state,
    };
    return CafeApi.put(deleteGuest(guest.id), body).then((res) async {
      final guestEdit = guestItemModelFromJson(json.encode(res.data['invitado']));
      guestBloc.add(UpdateItemGuest(guestEdit));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
