import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/models/event_model.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/views/home/card_category.dart';
import 'package:passport_unifranz_web/views/home/card_event.dart';

import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/provider/app_state.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/navigation_service.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/client/headers.dart';
import 'package:passport_unifranz_web/views/client/access/login_client.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool searchState = false;
  TextEditingController searchCtrl = TextEditingController();
  CategoryModel categorytodos = CategoryModel(title: 'Todos', icon: 'todos', user: 'todos', id: 'todos', state: true);
  @override
  void initState() {
    super.initState();
    callAllCategories();
    callAllEvents();
  }

  callAllCategories() async {
    final eventBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    debugPrint('obteniendo todas las categorias');

    return CafeApi.httpGet(categories(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['categorias'])}');
      eventBloc.add(UpdateListCategory(categoryModelFromJson(json.encode(res.data['categorias']))));
    });
  }

  callAllEvents() async {
    final eventBloc = BlocProvider.of<EventBloc>(context, listen: false);
    String currentRoute = window.location.href;
    String ultimo = currentRoute.split("#/").last;
    return CafeApi.httpGet(eventsCampus(ultimo)).then((res) async {
      final events = eventModelFromJson(json.encode(res.data['eventos']));
      debugPrint(' ressssss $events');
      eventBloc.add(UpdateListEvent(events));
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategoryId = Provider.of<AppState>(context).selectedCategoryId;
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Column(
          children: [
            HedersComponent(
              onPressLogin: () => loginshow(context),
              onPressLogout: () => logout(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InputComponent(
                        textInputAction: TextInputAction.done,
                        controllerText: searchCtrl,
                        onChanged: (value) {
                          if (value.trim().isNotEmpty) {
                            setState(() => searchState = true);
                          } else {
                            setState(() => searchState = false);
                          }
                        },
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))],
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
                        icon: Icons.search,
                        labelText: "Buscar",
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CategoryWidget(category: categorytodos),
                                for (final category in state.listCategories) CategoryWidget(category: category)
                              ],
                            ),
                          );
                        }))),
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Hoy es ${DateFormat('dd, MMMM yyyy ', "es_ES").format(DateTime.now())}')),
            Expanded(
              child: BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  final events = _getEvents(state, selectedCategoryId);
                  return (size.width > 1000)
                      ? GridView.count(
                          childAspectRatio: 1,
                          crossAxisCount: 4,
                          children: events.map(itemEvent).toList(),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: events.map(itemEvent).toList(),
                          ),
                        );
                },
              ),
            ),
          ],
        ));
  }

  List<EventModel> _getEvents(EventState state, String selectedCategoryId) {
    final allEvents = state.listEvents;
    if (searchState) {
      return allEvents
          .where((e) => e.title.trim().toUpperCase().contains(searchCtrl.text.trim().toUpperCase()))
          .toList();
    }
    if (selectedCategoryId == 'todos') return allEvents;

    return allEvents.where((e) => e.categoryIds.map((e) => e.id).contains(selectedCategoryId)).toList();
  }

  Widget itemEvent(EventModel event) {
    return Hero(
        tag: 'flipcardHero${event.id}',
        child: Material(
            type: MaterialType.transparency, // likely needed
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: EventWidget(
                event: event,
              ),
            )));
  }

  Future<bool> _onBackPressed() async {
    NavigationService.replaceTo('/');
    return false;
  }

  void loginshow(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) => const DialogLogin());
  }

  void logout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logoutStudent();
    NavigationService.replaceTo('/');
  }
}
