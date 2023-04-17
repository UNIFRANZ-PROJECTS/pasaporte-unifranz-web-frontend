import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/dashboard_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/admin/dashboard/dialog_filter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late TooltipBehavior _tooltip;
  late TooltipBehavior _tooltipBar;

  @override
  void initState() {
    callDataDashboard();
    _tooltip = TooltipBehavior(enable: true);
    _tooltipBar = TooltipBehavior(enable: true);
    super.initState();
  }

  callDataDashboard() async {
    debugPrint('obteniendo toda la info para dashboar');
    CafeApi.configureDio();
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context, listen: false);
    return CafeApi.httpGet(dashboard()).then((res) async {
      debugPrint(' ressssss ${res.data}');
      final countEvent = countEventFromJson(json.encode(res.data['countEvents']));
      final total = res.data['total'];
      final eventosCampus = eventosPorCampusFromJson(json.encode(res.data['eventosPorCampus']));
      final countModality = countEventFromJson(json.encode(res.data['modality']));
      final carrers = carrerFromJson(json.encode(res.data['carrers']));
      dashboardBloc.add(UpdateDashboard(countEvent, total, eventosCampus, countModality, carrers));
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context, listen: true).state;

    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Dashboard'),
              ButtonComponent(text: 'Generar Filtro', onPressed: () => showFilter(context)),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SfCircularChart(tooltipBehavior: _tooltip, series: <CircularSeries<CountEvent, String>>[
                            DoughnutSeries<CountEvent, String>(
                              // legendIconType: LegendIconType.diamond,
                              dataLabelSettings: const DataLabelSettings(isVisible: true),
                              dataSource: dashboardBloc.countEvent,
                              pointColorMapper: (CountEvent data, _) =>
                                  data.name == 'proximo' ? Colors.greenAccent : Colors.redAccent,
                              xValueMapper: (CountEvent data, _) => data.name,
                              yValueMapper: (CountEvent data, _) => data.cantidad,
                              dataLabelMapper: (CountEvent data, _) =>
                                  data.cantidad == 0 ? '' : '${data.name} : ${data.cantidad}',
                              // sortFieldValueMapper: (_ChartData data, _) => data.x,
                            )
                          ]),
                          Text(' ${dashboardBloc.totalEvents} EVENTOS')
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SfCircularChart(tooltipBehavior: _tooltip, series: <CircularSeries<CountEvent, String>>[
                            DoughnutSeries<CountEvent, String>(
                              // legendIconType: LegendIconType.diamond,
                              dataLabelSettings: const DataLabelSettings(isVisible: true),
                              dataSource: dashboardBloc.modality,
                              xValueMapper: (CountEvent data, _) => data.name,
                              yValueMapper: (CountEvent data, _) => data.cantidad,
                              dataLabelMapper: (CountEvent data, _) =>
                                  data.cantidad == 0 ? '' : '${data.name} : ${data.cantidad}',
                              // sortFieldValueMapper: (_ChartData data, _) => data.x,
                            )
                          ]),
                          Text(' ${dashboardBloc.totalEvents} EVENTOS')
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final item in dashboardBloc.listEventCampus)
                          Column(
                            children: [
                              Text(item.campus),
                              SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  primaryYAxis: NumericAxis(minimum: 0, maximum: getMax(item), interval: 1),
                                  tooltipBehavior: _tooltipBar,
                                  series: <CartesianSeries>[
                                    if (item.carreras.where((e) => e.proximo > 0).isNotEmpty)
                                      ColumnSeries<Carrera, String>(
                                          dataSource: item.carreras,
                                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                                          dataLabelMapper: (Carrera data, _) =>
                                              data.proximo != 0 ? '${data.proximo}' : '',
                                          pointColorMapper: (Carrera data, _) => Colors.greenAccent,
                                          xValueMapper: (Carrera data, _) => data.carrera,
                                          yValueMapper: (Carrera data, _) => data.proximo),
                                    if (item.carreras.where((e) => e.concluido > 0).isNotEmpty)
                                      ColumnSeries<Carrera, String>(
                                          dataSource: item.carreras,
                                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                                          dataLabelMapper: (Carrera data, _) =>
                                              data.concluido != 0 ? '${data.concluido}' : '',
                                          pointColorMapper: (Carrera data, _) => Colors.redAccent,
                                          xValueMapper: (Carrera data, _) => data.carrera,
                                          yValueMapper: (Carrera data, _) => data.concluido),
                                    if (item.carreras.where((e) => e.cancelado > 0).isNotEmpty)
                                      ColumnSeries<Carrera, String>(
                                          dataSource: item.carreras,
                                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                                          dataLabelMapper: (Carrera data, _) =>
                                              data.cancelado != 0 ? '${data.cancelado}' : '',
                                          pointColorMapper: (Carrera data, _) => Colors.orangeAccent,
                                          xValueMapper: (Carrera data, _) => data.carrera,
                                          yValueMapper: (Carrera data, _) => data.cancelado),
                                  ]),
                              Row(
                                children: [
                                  iconWidget(Colors.greenAccent, 'próximo'),
                                  iconWidget(Colors.redAccent, 'concluido'),
                                  iconWidget(Colors.orangeAccent, 'cancelado'),
                                ],
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]));
  }

  void showFilter(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            DialogWidget(component: DialogFilter(callFilter: (filter) => callFilter(filter))));
  }

  callFilter(FormData formData) {
    debugPrint('obteniendo toda la info para dashboar');
    CafeApi.configureDio();
    final dashboardBloc = BlocProvider.of<DashboardBloc>(context, listen: false);
    return CafeApi.post(dashboardFilter(), formData).then((res) async {
      debugPrint(' ressssss ${res.data}');
      final countEvent = countEventFromJson(json.encode(res.data['countEvents']));
      final total = res.data['total'];
      final eventosCampus = eventosPorCampusFromJson(json.encode(res.data['eventosPorCampus']));
      final countModality = countEventFromJson(json.encode(res.data['modality']));
      // final carrers = carrerFromJson(json.encode(res.data['carrers']));
      dashboardBloc.add(UpdateDashboard(countEvent, total, eventosCampus, countModality, null));
    });
  }

  Widget iconWidget(Color color, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [Icon(Icons.circle, color: color), Text(title)],
      ),
    );
  }

  double getMax(EventosPorCampus item) {
    int maxValue(int a, int b) => a > b ? a : b;
    int max = item.carreras.map((e) => [e.cancelado, e.proximo, e.concluido].reduce(maxValue)).reduce(maxValue);
    return double.parse('$max');
  }
}
