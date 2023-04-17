import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passport_unifranz_web/models/category_model.dart';

class CategoriesDataSource extends DataTableSource {
  final Function(CategoryModel) editTypeUser;
  final Function(CategoryModel, bool) deleteTypeUser;
  final List<CategoryModel> categories;

  CategoriesDataSource(this.categories, this.editTypeUser, this.deleteTypeUser);

  @override
  DataRow getRow(int index) {
    final CategoryModel category = categories[index];

    // final image = FadeInImage.assetNetwork(
    //   placeholder: 'gifs/loader.gif',
    //   image: category.icon,
    //   width: 35,
    //   height: 35,
    // );
    final image = SvgPicture.network(
      category.icon,
      width: 35,
      height: 35,
    );

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(category.title)),
      DataCell(image),
      DataCell(Text(category.state ? 'Activo' : 'Inactivo')),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => editTypeUser(category)),
          Transform.scale(
              scale: .5,
              child: Switch(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.red,
                  inactiveThumbColor: Colors.white,
                  activeColor: Colors.white,
                  value: category.state,
                  onChanged: (state) => deleteTypeUser(category, state)))
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}
