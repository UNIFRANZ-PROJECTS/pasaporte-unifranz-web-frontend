import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/guest_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/admin/guests/add_guest.dart';
import 'package:passport_unifranz_web/views/admin/guests/guests_datasource.dart';

class GuestsView extends StatefulWidget {
  const GuestsView({super.key});

  @override
  State<GuestsView> createState() => _GuestsViewState();
}

class _GuestsViewState extends State<GuestsView> {
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
    final guestBloc = BlocProvider.of<GuestBloc>(context, listen: true);

    final guestsDataSource = GuestsDataSource(
      guestBloc.state.listGuests,
      (typeUser) => showEditGuest(context, typeUser),
      (typeUser, state) => removeGuest(typeUser, state),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Expositores'),
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
    FormData formData = FormData.fromMap({
      'state': state,
    });
    return CafeApi.put(deleteGuest(guest.id), formData).then((res) async {
      final guestEdit = guestItemModelFromJson(json.encode(res.data['invitado']));
      guestBloc.add(UpdateItemGuest(guestEdit));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
