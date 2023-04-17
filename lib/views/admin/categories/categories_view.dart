import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/category/category_bloc.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';

import 'add_categorie.dart';
import 'categories_datasource.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  void initState() {
    callAllCategories();
    super.initState();
  }

  callAllCategories() async {
    debugPrint('obteniendo todas las categorias');
    final eventBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    return CafeApi.httpGet(categories(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['categorias'])}');
      eventBloc.add(UpdateListCategory(categoryModelFromJson(json.encode(res.data['categorias']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: true);

    final categoriesDataSource = CategoriesDataSource(
      categoryBloc.state.listCategories,
      (typeUser) => showEditCategory(context, typeUser),
      (typeUser, state) => removeCategory(typeUser, state),
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lista de Categorias'),
              ButtonComponent(text: 'Agregar nueva Categoria', onPressed: () => showAddCategory(context)),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                PaginatedDataTable(
                  sortAscending: categoryBloc.state.ascending,
                  sortColumnIndex: categoryBloc.state.sortColumnIndex,
                  columns: [
                    DataColumn(
                        label: const Text('Nombre'),
                        onSort: (colIndex, _) {
                          categoryBloc.add(UpdateSortColumnIndexCategory(colIndex));
                        }),
                    const DataColumn(
                      label: Text('Icono'),
                    ),
                    const DataColumn(label: Text('Estado')),
                    const DataColumn(label: Text('Acciones')),
                  ],
                  source: categoriesDataSource,
                  onPageChanged: (page) {
                    debugPrint('page: $page');
                  },
                )
              ],
            ),
          )
        ]));
  }

  void showAddCategory(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            const DialogWidget(component: AddCategoryForm(titleheader: 'Nueva Categoria')));
  }

  showEditCategory(BuildContext context, CategoryModel typeUser) {
    return showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: AddCategoryForm(item: typeUser, titleheader: typeUser.title)));
  }

  removeCategory(CategoryModel typeUser, bool state) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    CafeApi.configureDio();
    FormData formData = FormData.fromMap({
      'state': state,
    });
    return CafeApi.put(deleteCategories(typeUser.id), formData).then((res) async {
      final categoryEdit = categoryItemModelFromJson(json.encode(res.data['categoria']));
      categoryBloc.add(UpdateItemCategory(categoryEdit));
    }).catchError((e) {
      debugPrint('e $e');
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
