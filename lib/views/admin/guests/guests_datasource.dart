import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/guest_model.dart';

class GuestsDataSource extends DataTableSource {
  final List<GuestModel> guests;
  final Function(GuestModel)? editGuest;
  final Function(GuestModel, bool)? deleteGuest;

  GuestsDataSource(this.guests, this.editGuest, this.deleteGuest);

  @override
  DataRow getRow(int index) {
    final GuestModel guest = guests[index];

    final image = FadeInImage.assetNetwork(
      placeholder: 'gifs/loader.gif',
      image: guest.image,
      width: 35,
      height: 35,
    );

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(guest.firstName)),
      DataCell(Text(guest.lastName)),
      DataCell(ClipOval(child: image)),
      DataCell(Text(guest.specialty)),
      DataCell(Text(guest.description)),
      DataCell(Text(guest.state ? 'Activo' : 'Inactivo')),
      if (editGuest != null || deleteGuest != null)
        DataCell(Row(
          children: [
            IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editGuest!(guest)),
            Transform.scale(
                scale: .5,
                child: Switch(
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.red,
                    inactiveThumbColor: Colors.white,
                    activeColor: Colors.white,
                    value: guest.state,
                    onChanged: (state) => deleteGuest!(guest, state)))
          ],
        )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => guests.length;

  @override
  int get selectedRowCount => 0;
}
