import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:passport_unifranz_web/bloc/blocs.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/models/career_model.dart';
import 'package:passport_unifranz_web/models/guest_model.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/components/headers.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/models/event_model.dart';
import 'package:passport_unifranz_web/services/services.dart';

class AddEventForm extends StatefulWidget {
  final String titleheader;
  final EventModel? item;
  const AddEventForm({super.key, this.item, required this.titleheader});
// onEventAdd
  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  String? bytes;
  List<String> categoryIds = [];
  List<String> activitieIds = [];
  List<String> guestIds = [];
  List<String> carrerIds = [];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool stateLoading = false;
  bool textErrorCarrer = false;
  bool textErrorCategory = false;
  String hintTextDate = 'Rango de fechas del evento';
  String hintTextTimeStart = 'Hora aprox. de inicio del evento';
  String hintTextTimeEnd = 'Hora aprox. de fin del evento';
  @override
  void initState() {
    callAllCareers();
    callAllCategories();
    callAllGuests();
    if (widget.item != null) {
      setState(() {
        titleCtrl = TextEditingController(text: widget.item!.title);
        descriptionCtrl = TextEditingController(text: widget.item!.description);
        categoryIds = [...widget.item!.categoryIds.map((e) => e.id).toList()];
        carrerIds = [...widget.item!.careerIds.map((e) => e.id).toList()];
        guestIds = [...widget.item!.guestIds.map((e) => e.id).toList()];
        hintTextDate =
            '${DateFormat('y-M-d').format(widget.item!.start)} - ${DateFormat('y-M-d').format(widget.item!.end)}';
        hintTextTimeStart = DateFormat('HH:mm').format(widget.item!.start);
        hintTextTimeEnd = DateFormat('HH:mm').format(widget.item!.end);
        startDate = widget.item!.start;
        endDate = widget.item!.end;
        startTime = widget.item!.start;
        endTime = widget.item!.end;
      });
    }
    super.initState();
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

  callAllCategories() async {
    final eventBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    debugPrint('obteniendo todas las categorias');
    CafeApi.configureDio();
    return CafeApi.httpGet(categories(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['categorias'])}');
      eventBloc.add(UpdateListCategory(categoryModelFromJson(json.encode(res.data['categorias']))));
    });
  }

  callAllGuests() async {
    debugPrint('obteniendo todas los expositores');
    CafeApi.configureDio();
    final guestBloc = BlocProvider.of<GuestBloc>(context, listen: false);
    return CafeApi.httpGet(guests(null)).then((res) async {
      debugPrint(' ressssss ${json.encode(res.data['invitados'])}');
      guestBloc.add(UpdateListGuest(guestModelFromJson(json.encode(res.data['invitados']))));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              HedersComponent(
                title: widget.titleheader,
                initPage: false,
              ),
              (size.width > 1000)
                  ? Column(
                      children: [
                        Row(
                          children: [...titleDescription()],
                        ),
                        Row(
                          children: [...listSelect()],
                        ),
                        selectCareers()
                      ],
                    )
                  : Column(
                      children: [...titleDescription(), ...listSelect()],
                    ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        DateTimeWidget(
                            labelText: 'Fechas:',
                            hintText: hintTextDate,
                            selectDate: (value1, value2) {
                              setState(() {
                                startDate = DateTime.parse(value1);
                                endDate = DateTime.parse(value2);
                                hintTextDate = value1 == value2 ? value1 : '$value1 - $value2';
                              });
                            }),
                        Row(children: [
                          Expanded(
                            child: DateTimeWidget(
                              labelText: 'Hora inicio:',
                              hintText: hintTextTimeStart,
                              selectTime: (value) => setState(() {
                                hintTextTimeStart = DateFormat('HH:mm').format(value);
                                startTime = value;
                              }),
                            ),
                          ),
                          Expanded(
                            child: DateTimeWidget(
                              labelText: 'Hora fin:',
                              hintText: hintTextTimeEnd,
                              selectTime: (value) => setState(() {
                                hintTextTimeEnd = DateFormat('HH:mm').format(value);
                                endTime = value;
                              }),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  ImageInputComponent(
                    defect: widget.item == null ? null : widget.item!.image,
                    onPressed: (imageBytes) => setState(() => bytes = imageBytes),
                  ),
                ],
              ),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Evento', onPressed: () => createEvent())
                      : ButtonComponent(text: 'Actualizar Evento', onPressed: () => updateEvent())
                  : Center(
                      child: Image.asset(
                      'assets/gifs/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    ))
            ],
          ),
        ),
      ),
    );
  }

  Widget selectCareers() {
    final careerBloc = BlocProvider.of<CareerBloc>(context, listen: true).state;
    final listCarrer = [...careerBloc.listCareer];
    listCarrer.sort((a, b) => a.campus.compareTo(b.campus));
    final carrers = listCarrer.map((e) => MultiSelectItem<CareerModel>(e, '${e.abbreviation}-${e.campus}')).toList();
    List<CareerModel> carrerList = [];
    if (widget.item != null) {
      carrerList = careerBloc.listCareer.where((e) => widget.item!.careerIds.any((i) => i.id == e.id)).toList();
    }
    return SelectMultiple(
      initialValue: widget.item != null ? carrerList : const [],
      items: carrers,
      labelText: 'Carrera(s):',
      error: textErrorCarrer,
      textError: 'Seleccióna un Permiso',
      hintText: 'Carrera(s)',
      onChanged: (values) => setState(
        () => carrerIds = values.map((e) => careerItemModelFromJson(json.encode(e)).id).toList(),
      ),
    );
  }

  List<Widget> titleDescription() {
    return [
      Flexible(
        child: InputComponent(
            textInputAction: TextInputAction.done,
            controllerText: titleCtrl,
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
            labelText: "Titulo:",
            hintText: "Titulo del evento"),
      ),
      Flexible(
        child: InputComponent(
            controllerText: descriptionCtrl,
            onEditingComplete: () {},
            validator: (value) {
              if (value.trim() == "") return "Ingresa una descripción para el evento.";
              return null;
            },
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            textCapitalization: TextCapitalization.characters,
            labelText: "Descripción:",
            hintText: "Descripción del evento"),
      ),
    ];
  }

  List<Widget> listSelect() {
    final eventBloc = BlocProvider.of<CategoryBloc>(context, listen: true).state;
    final guestBloc = BlocProvider.of<GuestBloc>(context, listen: false).state;
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false).state;
    final categories = eventBloc.listCategories.map((e) => MultiSelectItem<CategoryModel>(e, e.title)).toList();
    final guests =
        guestBloc.listGuests.map((e) => MultiSelectItem<GuestModel>(e, '${e.firstName} ${e.lastName}')).toList();
    List<CategoryModel> categoryList = [];
    if (widget.item != null) {
      categoryList =
          categoryBloc.listCategories.where((e) => widget.item!.categoryIds.any((i) => i.id == e.id)).toList();
    }
    List<GuestModel> guestList = [];
    if (widget.item != null) {
      guestList = guestBloc.listGuests.where((e) => widget.item!.guestIds.any((i) => i.id == e.id)).toList();
    }
    return [
      Flexible(
        child: SelectMultiple(
            initialValue: widget.item != null ? categoryList : const [],
            items: categories,
            labelText: 'Categoria(s):',
            hintText: 'Categoria(s) del evento',
            error: textErrorCategory,
            textError: 'Seleccióna una Categoria',
            onChanged: (values) =>
                setState(() => categoryIds = values.map((e) => categoryItemModelFromJson(json.encode(e)).id).toList())),
      ),
      Flexible(
        child: SelectMultiple(
            initialValue: widget.item != null ? guestList : const [],
            items: guests,
            labelText: 'Expositor(es):',
            hintText: 'Expositor(es) del evento',
            error: false,
            onChanged: (values) =>
                setState(() => guestIds = values.map((e) => guestItemModelFromJson(json.encode(e)).id).toList())),
      ),
    ];
  }

  createEvent() async {
    final eventBloc = BlocProvider.of<EventBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    startDate = startDate.copyWith(hour: startTime.hour, minute: startTime.minute);
    endDate = endDate.copyWith(hour: endTime.hour, minute: endTime.minute);
    final Map<String, dynamic> body = {
      'title': titleCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'categoryIds': categoryIds,
      'guestIds': guestIds,
      'careerIds': carrerIds,
      'start': startDate.toString(),
      'end': endDate.toString(),
      'modality': 'presencial',
      'stateEvent': 'proximo',
      'archivo': bytes!,
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.post(eventsAdmin(null), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      eventBloc.add(AddItemListEvent(eventItemModelFromJson(json.encode(res.data['evento']))));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateEvent() async {
    final eventBloc = BlocProvider.of<EventBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    startDate = startDate.copyWith(hour: startTime.hour, minute: startTime.minute);
    endDate = endDate.copyWith(hour: endTime.hour, minute: endTime.minute);
    final Map<String, dynamic> body = {
      'title': titleCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'categoryIds': categoryIds,
      'guestIds': guestIds,
      'careerIds': carrerIds,
      'start': startDate.toString(),
      'end': endDate.toString(),
      'modality': 'presencial',
      'stateEvent': 'proximo',
      'archivo': bytes != null ? bytes! : null,
    };
    setState(() => stateLoading = !stateLoading);
    return CafeApi.put(eventsAdmin(widget.item!.id), body).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final categoryEdit = eventItemModelFromJson(json.encode(res.data['evento']));
      eventBloc.add(UpdateItemEvent(categoryEdit));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
