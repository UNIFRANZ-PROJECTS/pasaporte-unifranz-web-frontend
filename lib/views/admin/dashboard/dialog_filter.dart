import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/career_model.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/models/dashboard_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/client/headers.dart';

class DialogFilter extends StatefulWidget {
  final Function(FormData) callFilter;
  const DialogFilter({super.key, required this.callFilter});

  @override
  State<DialogFilter> createState() => _DialogFilterState();
}

class _DialogFilterState extends State<DialogFilter> {
  String hintTextDate = 'Rango de fechas del evento';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<String> campusIds = [];
  List<String> careerIds = [];
  List<String> categoryIds = [];
  List<String> modalityIds = [];
  @override
  void initState() {
    callAllCategories();
    super.initState();
  }

  callAllCategories() async {
    final eventBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    debugPrint('obteniendo todas las categorias');
    CafeApi.configureDio();
    return CafeApi.httpGet(categories(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['categorias'])}');
      eventBloc.add(UpdateListCategory(categoryModelFromJson(json.encode(res.data['categorias']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context, listen: true).state;
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: true).state;
    List modalidades = ['presencial', 'virtual'];
    final campusList = dashboardBloc.carrers.map((e) => MultiSelectItem<Carrer>(e, e.campus)).toList();
    final categoryList = categoryBloc.listCategories.map((e) => MultiSelectItem<CategoryModel>(e, e.title)).toList();
    final modalidadesList = modalidades.map((e) => MultiSelectItem<String>(e, e)).toList();
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HedersComponent(
              title: 'Filtro',
              initPage: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SelectMultiple(
                            initialValue: const [],
                            items: campusList,
                            labelText: 'Categoria(s):',
                            hintText: 'Categoria(s) del evento',
                            onChanged: (values) => setState(() =>
                                campusIds = values.map((e) => carrerItemFromJson(json.encode(e)).campus).toList())),
                      ),
                      Flexible(
                        child: SelectMultiple(
                            initialValue: const [],
                            items: categoryList,
                            labelText: 'Categoria(s):',
                            hintText: 'Categoria(s) del evento',
                            onChanged: (values) => setState(() => categoryIds =
                                values.map((e) => categoryItemModelFromJson(json.encode(e)).id).toList())),
                      ),
                      Flexible(
                        child: SelectMultiple(
                            initialValue: const [],
                            items: modalidadesList,
                            labelText: 'Modalidad(es):',
                            hintText: 'Categoria(s) del evento',
                            onChanged: (values) =>
                                setState(() => modalityIds = values.map((e) => e as String).toList())),
                      ),
                      Flexible(
                        child: DateTimeWidget(
                            labelText: 'Fechas:',
                            hintText: hintTextDate,
                            selectDate: (value1, value2) {
                              setState(() {
                                startDate = DateTime.parse(value1);
                                endDate = DateTime.parse(value2);
                                hintTextDate = value1 == value2 ? value1 : '$value1 - $value2';
                              });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      for (final item in campusIds)
                        Flexible(
                          child: SelectMultiple(
                              initialValue: const [],
                              items: dashboardBloc.carrers
                                  .firstWhere((i) => i.campus == item)
                                  .carreras
                                  .map((e) => MultiSelectItem<CareerModel>(e, e.abbreviation))
                                  .toList(),
                              labelText: 'Carrera(s) de $item:',
                              hintText: 'Categoria(s) del evento',
                              onChanged: (values) => setState(() => careerIds
                                  .addAll(values.map((e) => careerItemModelFromJson(json.encode(e)).id).toList()))),
                        ),
                    ],
                  ),
                  ButtonComponent(text: 'Generar Filtro', onPressed: () => generateFilter())
                ],
              )),
            ),
          ],
        ));
  }

  generateFilter() {
    FormData formData = FormData.fromMap({
      'carrers': careerIds,
      'categories': categoryIds,
      'modalities': modalityIds,
      'start': startDate,
      'end': endDate,
    });
    Navigator.pop(context);
    return widget.callFilter(formData);
  }
}
