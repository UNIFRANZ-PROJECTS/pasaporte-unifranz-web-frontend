import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/inputs/search.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/models/event_model.dart';
import 'package:passport_unifranz_web/provider/auth_provider.dart';
import 'package:passport_unifranz_web/views/home/card_category.dart';
import 'package:passport_unifranz_web/views/home/card_event.dart';
import 'package:passport_unifranz_web/provider/app_state.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/services/navigation_service.dart';
import 'package:passport_unifranz_web/services/services.dart';
import 'package:passport_unifranz_web/views/home/header_home.dart';
import 'package:passport_unifranz_web/views/home/access/login_client.dart';
import 'package:passport_unifranz_web/views/home/home_page_background.dart';
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
    String ultimo = currentRoute.split("/").last;
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

    String? title;
    switch (window.location.href.split("/").last) {
      case 'lp':
        title = 'La Paz';
        break;
      case 'ea':
        title = 'El Alto';
        break;
      case 'cbba':
        title = 'Cochabamba';
        break;
      case 'sc':
        title = 'Santa Cruz';
        break;
      default:
        title = '';
    }
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Stack(children: <Widget>[
          HomePageBackground(
            screenHeight: MediaQuery.of(context).size.height,
          ),
          Column(
            children: [
              HaaderHome(
                title: 'Eventos sede $title',
                logIn: () => loginshow(context),
                logOut: () => logout(context),
              ),
              (size.width > 1000)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: listComponents(),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: listComponents(),
                    ),
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
          )
        ]));
  }

  List<Widget> listComponents() {
    return [
      SearchWidget(
        isWhite: true,
        controllerText: searchCtrl,
        onChanged: (value) {
          if (value.trim().isNotEmpty) {
            setState(() => searchState = true);
          } else {
            setState(() => searchState = false);
          }
        },
      ),
      Flexible(
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
    ];
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
