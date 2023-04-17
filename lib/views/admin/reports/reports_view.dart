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
import 'package:passport_unifranz_web/models/event_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/admin/reports/events_datasource.dart';
import 'package:printing/printing.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  bool stateLoading = false;
  String hintTextDate = 'Rango de fechas del evento';
  DateTime? startDate;
  DateTime? endDate;
  List<String> campusIds = [];
  List<String>? careerIds;
  List<String>? categoryIds;
  List<String>? modalityIds;
  @override
  void initState() {
    callAllCategories();
    callAllEvents();
    callAllCareers();
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

  callAllCareers() async {
    final careerBloc = BlocProvider.of<CareerBloc>(context, listen: false);
    debugPrint('obteniendo todas las carreras');
    CafeApi.configureDio();
    return CafeApi.httpGet(careers()).then((res) async {
      debugPrint(' CARRERAS ${json.encode(res.data['carreras'])}');
      careerBloc.add(UpdateListCareer(careerModelFromJson(json.encode(res.data['carreras']))));
    });
  }

  callAllEvents() async {
    setState(() => stateLoading = !stateLoading);
    final reportBloc = BlocProvider.of<ReportBloc>(context, listen: false);
    debugPrint('obteniendo todos los eventos');
    return CafeApi.httpGet(events(null)).then((res) async {
      setState(() => stateLoading = !stateLoading);
      debugPrint(' ressssss ${json.encode(res.data['eventos'])}');
      reportBloc.add(UpdateListReportEvent(eventModelFromJson(json.encode(res.data['eventos']))));
    }).catchError((err) {
      setState(() => stateLoading = !stateLoading);
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
    final reportBloc = BlocProvider.of<ReportBloc>(context, listen: true);

    final eventsDataSource = ReportsDataSource(
      reportBloc.state.listEvents,
    );

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Reportes'),
              const Spacer(),
              ButtonComponent(text: 'Descargar', onPressed: () => downloadReport(context)),
            ],
          ),
          Expanded(
            flex: 1,
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
                          labelText: 'Sede(s):',
                          hintText: 'Sede(s) del evento',
                          onChanged: (values) {
                            setState(() => campusIds = values.map((e) => (e as Carrer).campus).toList());
                            if (careerIds != null) {
                              final list = values.map((e) => (e as Carrer).carreras.map((e) => e.id).toList()).toList();
                              final flatList = list.expand((element) => element).toList();
                              setState(() => careerIds!.removeWhere((e) => !flatList.contains(e)));
                              return showFilter(context);
                            }
                          }),
                    ),
                    Flexible(
                      child: SelectMultiple(
                          initialValue: const [],
                          items: categoryList,
                          labelText: 'Categoria(s):',
                          hintText: 'Categoria(s) del evento',
                          onChanged: (values) {
                            setState(() =>
                                categoryIds = values.map((e) => categoryItemModelFromJson(json.encode(e)).id).toList());
                            return showFilter(context);
                          }),
                    ),
                    Flexible(
                      child: SelectMultiple(
                          initialValue: const [],
                          items: modalidadesList,
                          labelText: 'Modalidad(es):',
                          hintText: 'Categoria(s) del evento',
                          onChanged: (values) {
                            setState(() => modalityIds = values.map((e) => e as String).toList());
                            return showFilter(context);
                          }),
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
                            return showFilter(context);
                          }),
                    ),
                  ],
                ),
                Row(
                  children: buildCampusSelectMultiple(),
                ),
              ],
            )),
          ),
          Expanded(
            flex: 2,
            child: stateLoading
                ? Center(
                    child: Image.asset(
                    'assets/gifs/load.gif',
                    fit: BoxFit.cover,
                    height: 20,
                  ))
                : ListView(
                    children: [
                      PaginatedDataTable(
                        sortAscending: reportBloc.state.ascending,
                        sortColumnIndex: reportBloc.state.sortColumnIndex,
                        columns: [
                          DataColumn(
                              label: const Text('Nombre'),
                              onSort: (colIndex, _) {
                                // eventBloc.add(UpdateSortColumnIndexCategory(colIndex));
                              }),
                          const DataColumn(
                            label: Text('Imagen'),
                          ),
                          DataColumn(
                              label: const Text('Inicio'),
                              onSort: (colIndex, _) {
                                // eventBloc.add(UpdateSortColumnIndexCategory(colIndex));
                              }),
                          DataColumn(
                              label: const Text('Fin'),
                              onSort: (colIndex, _) {
                                // eventBloc.add(UpdateSortColumnIndexCategory(colIndex));
                              }),
                          const DataColumn(label: Text('Estado')),
                          const DataColumn(label: Text('Modalidad')),
                          const DataColumn(label: Text('Estado')),
                        ],
                        source: eventsDataSource,
                        onPageChanged: (page) {
                          debugPrint('page: $page');
                        },
                      )
                    ],
                  ),
          )
        ]));
  }

  List<Widget> buildCampusSelectMultiple() {
    List<Widget> children = [];

    final dashboardBloc = BlocProvider.of<DashboardBloc>(context, listen: true).state;
    for (final item in campusIds) {
      List<CareerModel> campusCareers = dashboardBloc.carrers.firstWhere((i) => i.campus == item).carreras;

      List<MultiSelectItem<CareerModel>> campusCareerItems =
          campusCareers.map((e) => MultiSelectItem<CareerModel>(e, e.abbreviation)).toList();

      Flexible campusSelectMultiple = Flexible(
        child: SelectMultiple(
          initialValue: const [],
          items: campusCareerItems,
          labelText: 'Carrera(s) de $item:',
          hintText: 'Carrera(s) de $item',
          onChanged: (values) {
            if (careerIds != null) {
              setState(() => careerIds!.removeWhere((e) => campusCareers.map((e) => e.id).contains(e)));
            }
            setState(() => careerIds = [...careerIds ?? [], ...values.map((e) => (e as CareerModel).id).toList()]);
            showFilter(context);
          },
        ),
      );

      children.add(campusSelectMultiple);
    }

    return children;
  }

  showFilter(BuildContext context) {
    setState(() => stateLoading = !stateLoading);
    final reportBloc = BlocProvider.of<ReportBloc>(context, listen: false);
    debugPrint('obteniendo toda la info para reportes');
    CafeApi.configureDio();
    FormData formData = FormData.fromMap({
      'carrers': careerIds,
      'categories': categoryIds,
      'modalities': modalityIds,
      'start': startDate,
      'end': endDate,
    });

    return CafeApi.post(reportsFilter(), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      debugPrint(' ressssss ${json.encode(res.data['eventos'])}');
      reportBloc.add(UpdateListReportEvent(eventModelFromJson(json.encode(res.data['eventos']))));
    }).catchError((err) {
      setState(() => stateLoading = !stateLoading);
    });
  }

  downloadReport(BuildContext context) {
    debugPrint('obteniendo toda la info para dashboar');
    CafeApi.configureDio();
    FormData formData = FormData.fromMap({
      'carrers': careerIds,
      'categories': categoryIds,
      'modalities': modalityIds,
      'start': startDate,
      'end': endDate,
    });
    return CafeApi.post(reportsDownload(), formData).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['base64'])}');
      final bytes = base64Decode(res.data['base64']);
      await Printing.sharePdf(bytes: bytes, filename: 'reporte.xlsx');
    });
  }
}
